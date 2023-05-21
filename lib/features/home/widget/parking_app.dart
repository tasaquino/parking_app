import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/home/screens/home.dart';
import 'package:parking_app/features/user/presentation/providers/user_repository_provider.dart';
import 'package:parking_app/features/user/presentation/providers/user_state.dart';
import 'package:parking_app/features/user/presentation/screens/login.dart';
import 'package:parking_app/theme/theme.dart';

class ParkingApp extends ConsumerWidget {
  const ParkingApp({
    super.key,
    required this.signedIn,
  });

  final bool signedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userNotifierProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: state.state == UserPossibleStates.loggedIn
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
