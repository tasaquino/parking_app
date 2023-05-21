import 'package:parking_app/features/user/data/models/user.dart';

abstract class UserRepository {
  Future<bool> logout();
  Future<AppUser?> signIn();
  Future<String> getAuthToken();
  String getUserID();
  Future<AppUser?> fetchUser();
  bool isUserLoggedIn();
}
