import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/user/data/models/user.dart';
import 'package:parking_app/features/user/domain/user_interactor.dart';
import 'package:parking_app/features/user/presentation/providers/user_notifier.dart';
import 'package:parking_app/features/user/presentation/providers/user_state.dart';
import 'package:test/test.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import 'user_notifier_test.mocks.dart';

//flutter pub run build_runner build - run it to generate mock files

@GenerateMocks([UserInteractor])
void main() {
  const appUser = AppUser(id: "id", name: "name", email: "email");
  late UserInteractor interactor;
  late UserNotifier notifier;
  const initialState = UserState(state: UserPossibleStates.loggedOut);

  setUpAll(() {
    interactor = MockUserInteractor();
  });
  stateNotifierTest<UserNotifier, UserState>(
    'Should present proper states when logging in user',
    build: () {
      notifier = UserNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.signIn()).thenAnswer((realInvocation) async => appUser);
      when(interactor.fetchUser())
          .thenAnswer((realInvocation) async => appUser);
    },
    actions: (notifier) async {
      await notifier.login();
    },
    expect: () => [
      initialState.copyWith(state: UserPossibleStates.loggingIn),
      initialState.copyWith(state: UserPossibleStates.loggedIn, user: appUser),
    ],
  );

  stateNotifierTest<UserNotifier, UserState>(
    'Should present proper states when fails to log in user',
    build: () {
      notifier = UserNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.signIn()).thenAnswer((realInvocation) async => null);
      when(interactor.fetchUser())
          .thenAnswer((realInvocation) async => appUser);
    },
    actions: (notifier) async {
      await notifier.login();
    },
    expect: () => [
      initialState.copyWith(state: UserPossibleStates.loggingIn),
      initialState.copyWith(state: UserPossibleStates.loggedOut, user: null),
    ],
  );

  stateNotifierTest<UserNotifier, UserState>(
    'Should present proper states when logging out user',
    build: () {
      notifier = UserNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.logout()).thenAnswer((realInvocation) async => true);
    },
    actions: (notifier) async {
      await notifier.logout();
    },
    expect: () => [
      initialState.copyWith(state: UserPossibleStates.loggingOut),
      initialState.copyWith(state: UserPossibleStates.loggedOut, user: null),
    ],
  );

  stateNotifierTest<UserNotifier, UserState>(
    'Should present proper states when logging out user fails',
    build: () {
      notifier = UserNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.logout()).thenAnswer((realInvocation) async => false);
    },
    actions: (notifier) async {
      await notifier.logout();
    },
    expect: () => [
      initialState.copyWith(state: UserPossibleStates.loggingOut),
      initialState.copyWith(
        state: UserPossibleStates.loggedIn,
      ),
    ],
  );

  stateNotifierTest<UserNotifier, UserState>(
    'Should present proper states when setting initial state',
    build: () {
      notifier = UserNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.isUserLoggedIn()).thenAnswer((realInvocation) => true);
      when(interactor.fetchUser())
          .thenAnswer((realInvocation) async => appUser);
    },
    actions: (notifier) async {
      await notifier.setInitialState();
    },
    expect: () =>
        [const UserState(state: UserPossibleStates.loggedIn, user: appUser)],
  );
}
