import 'package:flutter/material.dart';
//import 'features/home/presentation/screens/basic_home_page.dart';
import 'splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:  AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

