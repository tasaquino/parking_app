import 'package:parking_app/features/user/data/models/user.dart';
import 'package:parking_app/features/user/data/user_repository.dart';
import 'package:parking_app/features/user/domain/user_interactor.dart';

class UserInteractorImpl implements UserInteractor {
  const UserInteractorImpl(this.userRepository);
  final UserRepository userRepository;

  @override
  Future<AppUser?> fetchUser() {
    return userRepository.fetchUser();
  }

  @override
  Future<String> getAuthToken() {
    return userRepository.getAuthToken();
  }

  @override
  String getUserID() {
    return userRepository.getUserID();
  }

  @override
  Future<bool> logout() {
    return userRepository.logout();
  }

  @override
  Future<AppUser?> signIn() {
    return userRepository.signIn();
  }

  @override
  bool isUserLoggedIn() {
    return userRepository.isUserLoggedIn();
  }
}
