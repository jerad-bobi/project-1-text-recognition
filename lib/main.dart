import 'package:flutter/material.dart'; // Import the home_page.dart file
import 'welcome_page.dart'; // Import the login page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // System default theme
      home: const WelcomePage(), // Start with login page
    );
  }
}
