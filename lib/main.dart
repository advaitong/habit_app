import 'package:flutter/material.dart';
import 'package:habit_app/pages/intro_page.dart';
import 'package:habit_app/theme/dark_mode.dart';
import 'package:habit_app/theme/light_mode.dart';
import 'package:habit_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
      theme: darkMode,
    );
  }
}
