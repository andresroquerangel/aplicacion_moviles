import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData lightTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 211, 19, 163)
      )
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color.fromARGB(255, 40, 41, 40)
      )
    );
  }
}
