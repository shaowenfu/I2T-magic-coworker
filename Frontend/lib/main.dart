import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'pages/welcome/welcome_page.dart';
import 'pages/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppConstants.welcomeRoute,
      routes: {
        AppConstants.welcomeRoute: (context) => const WelcomePage(),
        AppConstants.homeRoute: (context) => const MainNavigation(),
      },
    );
  }
}
