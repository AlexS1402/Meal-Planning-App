import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/main_navigation.dart';
import 'views/settings_profile.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/main': (context) => MainNavigation(),  // Assuming this is the home after login
        '/login_screen': (context) => LoginScreen(),  // Ensure this matches the Navigator call
        '/settings': (context) => SettingsProfile(),  // Add if you have a settings page route
      },
    );
  }
}
