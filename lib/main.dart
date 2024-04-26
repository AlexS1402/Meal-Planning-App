import 'package:flutter/material.dart';
import 'package:mealplanningapp/views/home_dashboard.dart'; // Replace with your actual home screen import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.green, // Optional: Used for darker version if needed in your design
          secondary: Colors.greenAccent, // Used for elements like the Floating Action Button
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green, // Text color
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.green, side: const BorderSide(color: Colors.green), // Border color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      home: const HomeScreen(), // Replace with your actual home screen widget
    );
  }
}
