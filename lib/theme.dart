import 'package:flutter/material.dart';

class MyAppTheme {
  static get lightTheme => ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        inputDecorationTheme: const InputDecorationTheme().copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}
