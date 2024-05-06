import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mealplanningapp/services/api/api_service.dart'; // Adjust the path as needed
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showLogoutDialog(context),
          child: Text('Logout'),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    // Call the logout method from your ApiService or directly hit the backend endpoint
    await ApiService().logout();
    Navigator.of(context).pushReplacementNamed('/login_screen');
  }
}
