import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:parking_app/features/user/data/models/user.dart';
import 'package:parking_app/features/user/data/user_repository.dart';
import 'package:parking_app/features/user/data/user_repository_impl.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/utils/app_configuration.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'user_repository_test.mocks.dart';

const userJson = """{
  "email": "UserName@gmail.com",
  "id": "ABCDEF123456789",
  "name": "UserName",
  "photoUrl": "https://userPhoto"
}""";

Future<Uri> buildUri(String userID, String token) async {
  return Uri.https(AppConfiguration.projectUrl, 'users/$userID.json',
      {'auth': token, 'id': userID});
}

Future<Uri> buildUriFor(String userID, String token) async {
  return Uri.https(
      AppConfiguration.projectUrl, 'users/$userID.json', {'auth': token});
}

@GenerateMocks([
  http.Client,
  UserRepository,
])
void main() {
  late UserRepository userRepository;
  late http.Client httpClient;
  late FirebaseAuth mockFirebaseAuth;
  late AuthCredential mockAuthCredential;
  late MockUser user;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount?.authentication;
    mockAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
    await mockFirebaseAuth.signInWithCredential(mockAuthCredential);

    httpClient = MockClient();
    userRepository =
        UserRepositoryImpl(httpClient, mockFirebaseAuth, googleSignIn);
  });

  group('User Repository Test', () {
    test('Should fetch user with success', () async {
      String userID = userRepository.getUserID();
      String token = await userRepository.getAuthToken();
      final uri = await buildUri(userID, token);
      when(httpClient.get(uri, headers: {
        'Content-Type': 'application/json',
      })).thenAnswer((_) async => http.Response(userJson, 200));

      final result = await userRepository.fetchUser();
      expect(result?.name, "UserName");
      expect(result?.email, "UserName@gmail.com");
      expect(result?.id, "ABCDEF123456789");
      expect(result?.photoUrl, "https://userPhoto");
    });

    test('Should logout user with success', () async {
      String userID = userRepository.getUserID();
      String token = await userRepository.getAuthToken();
      final uri = await buildUri(userID, token);
      when(httpClient.get(uri, headers: {
        'Content-Type': 'application/json',
      })).thenAnswer((_) async => http.Response(userJson, 200));

      final result = await userRepository.logout();
      expect(result, true);
      expect(userRepository.isUserLoggedIn(), false);
    });

    test('Should sign in user with success', () async {
      String userID = userRepository.getUserID();
      String token = await userRepository.getAuthToken();

      final uri = await buildUriFor(userID, token);
      when(httpClient.patch(uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "id": user.uid,
            "name": user.displayName,
            "email": user.email,
            "photoUrl": user.photoURL,
          }))).thenAnswer((_) async => http.Response(userJson, 200));

      final result = await userRepository.signIn();
      expect(result, isA<AppUser>());
      expect(userRepository.isUserLoggedIn(), true);
    });
  });
}
