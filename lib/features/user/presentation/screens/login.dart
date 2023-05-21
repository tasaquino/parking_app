import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/user/presentation/providers/user_repository_provider.dart';
import 'package:parking_app/features/user/presentation/providers/user_state.dart';
import 'package:parking_app/features/home/screens/home.dart';
import 'package:parking_app/features/user/presentation/providers/user_notifier.dart';

// <a href="https://www.flaticon.com/free-icons/parking" title="parking icons">Parking icons created by Freepik - Flaticon</a>
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _errorMessage = '';
  late UserNotifier notifier;
  @override
  void initState() {
    super.initState();

    notifier = ref.read(userNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.setInitialState();
    });
  }

  void navigateHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return const HomeScreen();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/parking_icon.png",
                width: 150,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: 30),
              Text(
                'Flutter Parking',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 50),
              OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style,
                  onPressed: () async {
                    final state = ref.watch(userNotifierProvider);
                    await notifier.login();
                    if (state.state == UserPossibleStates.loggedIn) {
                      navigateHome();
                    } else {
                      setState(() {
                        _errorMessage = 'Please try again...';
                      });
                    }
                  },
                  child: const Text('Login with Google')),
              Text(_errorMessage),
            ]),
      ),
    );
  }
}
