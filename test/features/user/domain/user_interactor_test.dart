import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/user/data/models/user.dart';
import 'package:parking_app/features/user/data/user_repository.dart';
import 'package:parking_app/features/user/domain/user_interactor.dart';
import 'package:parking_app/features/user/domain/user_interactor_impl.dart';

import '../data/user_repository_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late UserRepository repository;
  late UserInteractor interactor;
  const appUser =
      AppUser(id: "id", name: "name", email: "email", photoUrl: "photo");
  setUpAll(() {
    repository = MockUserRepository();
    interactor = UserInteractorImpl(repository);
  });
  group('User Interactor Tests', () {
    test('Should fetch user with success', () async {
      when(repository.fetchUser()).thenAnswer((realInvocation) async =>
          const AppUser(
              id: "id", name: "name", email: "email", photoUrl: "photo"));

      final result = await interactor.fetchUser();
      expect(result, isA<AppUser>());
      expect(result?.id, "id");
      expect(result?.name, "name");
      expect(result?.email, "email");
      expect(result?.photoUrl, "photo");
    });

    test('Should fetch authToken with success', () async {
      when(repository.getAuthToken()).thenAnswer((_) async => "token");

      final result = await interactor.getAuthToken();
      expect(result, "token");
    });

    test('Should fetch user ID with success', () async {
      when(repository.getUserID()).thenAnswer((_) => "userID");

      final result = interactor.getUserID();
      expect(result, "userID");
    });

    test('Should signin user with success', () async {
      when(repository.signIn()).thenAnswer((_) async => appUser);

      final result = await interactor.signIn();
      expect(result, isA<AppUser>());
    });

    test('Should logout with success', () async {
      when(repository.logout()).thenAnswer((_) async => true);
      when(repository.isUserLoggedIn()).thenAnswer((_) => false);

      final result = await interactor.logout();
      final isLoggedIn = interactor.isUserLoggedIn();
      expect(result, true);
      expect(isLoggedIn, false);
    });
  });
}
