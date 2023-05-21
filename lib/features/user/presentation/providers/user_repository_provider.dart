// coverage:ignore-file
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:parking_app/features/user/data/user_repository_impl.dart';
import 'package:parking_app/features/user/domain/user_interactor.dart';
import 'package:parking_app/features/user/domain/user_interactor_impl.dart';
import 'package:parking_app/features/user/presentation/providers/user_notifier.dart';
import 'package:parking_app/features/user/presentation/providers/user_state.dart';

final userRepositoryProvider = Provider((_) {
  return UserRepositoryImpl(
      http.Client(), FirebaseAuth.instance, GoogleSignIn());
});

final userInteractorProvider = Provider<UserInteractor>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  final interactor = UserInteractorImpl(repository);

  return interactor;
});

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) {
  final interactor = ref.watch(userInteractorProvider);
  return UserNotifier(interactor);
});
