import 'package:flutter/material.dart';

var colorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 204, 79, 226));

var darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 89, 20, 118),
    brightness: Brightness.dark);

var darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    cardTheme: const CardTheme().copyWith(
      color: darkColorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    ));

var lightTheme = ThemeData().copyWith(
    useMaterial3: true,
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.onBackground,
            backgroundColor: const Color.fromARGB(255, 237, 198, 211))),
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: colorScheme.onPrimaryContainer,
      foregroundColor: colorScheme.primaryContainer,
    ),
    iconTheme: const IconThemeData().copyWith(color: Colors.pink[200]),
    cardTheme: const CardTheme().copyWith(
      color: colorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    ));
