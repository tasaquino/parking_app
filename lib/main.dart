import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking_app/features/home/widget/parking_app.dart';
import 'package:parking_app/utils/app_configuration.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseConfiguration.currentPlatform,
  );

  final signedIn = FirebaseAuth.instance.currentUser != null;

  runApp(
    ProviderScope(
      child: ParkingApp(signedIn: signedIn),
    ),
  );
}
