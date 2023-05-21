import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking_app/features/user/data/models/user.dart';
import 'package:parking_app/features/user/data/user_repository.dart';
import 'package:parking_app/utils/app_configuration.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._httpClient, this._firebaseAuth, this._googleSignin);
  final http.Client _httpClient;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignin;

  @override
  String getUserID() {
    return _firebaseAuth.currentUser?.uid ?? "";
  }

  @override
  Future<bool> logout() async {
    await _firebaseAuth.signOut();
    return _firebaseAuth.currentUser == null;
  }

  Future<bool> _save(AppUser user) async {
    final url = await buildUserUriFor(user.id);
    final response = await _httpClient.patch(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "id": user.id,
          "name": user.name,
          "email": user.email,
          "photoUrl": user.photoUrl,
        }));
    return response.statusCode == 200;
  }

  @override
  Future<String> getAuthToken() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser?.getIdToken() ?? Future.value("");
    }
    return Future.value("");
  }

  Future<Uri> buildUserUriFor(String userID) async {
    final token = await _firebaseAuth.currentUser?.getIdToken();
    return Uri.https(
        AppConfiguration.projectUrl, 'users/$userID.json', {'auth': token});
  }

  @override
  Future<AppUser?> fetchUser() async {
    final token = await _firebaseAuth.currentUser?.getIdToken();
    final url = Uri.https(AppConfiguration.projectUrl,
        'users/${getUserID()}.json', {'auth': token, 'id': getUserID()});
    final response = await _httpClient.get(url, headers: {
      'Content-Type': 'application/json',
    });
    AppUser? user;
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      user = AppUser(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          photoUrl: data["photoUrl"]);
    }

    return user;
  }

  @override
  Future<AppUser?> signIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignin.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, handle the UserCredential
    final user = await _firebaseAuth.signInWithCredential(credential);
    final id = _firebaseAuth.currentUser?.uid;
    if (id != null) {
      final newUser = AppUser(
          id: id,
          name: user.user?.displayName ?? "",
          email: user.user?.email ?? "",
          photoUrl: user.user?.photoURL);
      final result = await _save(newUser);
      if (result) {
        return newUser;
      }
    }

    return null;
  }

  @override
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
