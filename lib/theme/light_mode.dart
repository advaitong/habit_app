import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    // Surface: Main background color (Very light/off-white)
    surface: Color(0xFFFAFAFA),

    // Primary: The accent color (kept consistent with dark mode's vibrant red)
    primary: Color.fromARGB(255, 255, 83, 83),

    // Secondary: Used for less prominent elements/dividers (Light gray)
    secondary: Color(0xFFE0E0E0),

    // Tertiary: Used for card backgrounds or elevated elements (Medium light grey)
    tertiary: Color(0xFFCCCCCC),

    // Inverse Primary: Text color for light background (Dark Gray/Black)
    inversePrimary: Color(0xFF1A1A1A),
  ),
);
