import 'package:equatable/equatable.dart';
import 'package:parking_app/features/user/data/models/user.dart';

enum UserPossibleStates {
  loggedIn,
  loggedOut,
  loggingIn,
  loggingOut,
}

class UserState extends Equatable {
  final UserPossibleStates state;
  final AppUser? user;

  const UserState({this.state = UserPossibleStates.loggedOut, this.user});

  UserState copyWith(
      {UserPossibleStates? state, AppUser? user, String? token}) {
    return UserState(state: state ?? this.state, user: user ?? this.user);
  }

  @override
  List<Object?> get props => [user, state];
}
