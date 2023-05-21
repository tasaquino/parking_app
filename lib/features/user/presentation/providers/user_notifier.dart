import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/user/domain/user_interactor.dart';
import 'package:parking_app/features/user/presentation/providers/user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  final UserInteractor _interactor;
  UserNotifier(this._interactor)
      : super(const UserState(state: UserPossibleStates.loggedOut));

  Future<void> setInitialState() async {
    if (_interactor.isUserLoggedIn()) {
      final user = await _interactor.fetchUser();
      state = UserState(state: UserPossibleStates.loggedIn, user: user);
    } else {
      state = const UserState(state: UserPossibleStates.loggedOut);
    }
  }

  Future<void> login() async {
    state = const UserState(state: UserPossibleStates.loggingIn);
    final user = await _interactor.signIn();

    state = user != null
        ? state.copyWith(state: UserPossibleStates.loggedIn, user: user)
        : state.copyWith(state: UserPossibleStates.loggedOut, user: null);
  }

  Future<void> logout() async {
    state = const UserState(state: UserPossibleStates.loggingOut);
    final result = await _interactor.logout();

    state = result
        ? state.copyWith(state: UserPossibleStates.loggedOut, user: null)
        : state.copyWith(state: UserPossibleStates.loggedIn);
  }
}
