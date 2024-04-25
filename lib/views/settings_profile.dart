import 'package:flutter/material.dart';

class SettingsProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings/Profile'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Edit Profile'),
            onTap: () {
              // Navigate to profile edit page
            },
          ),
          ListTile(
            title: Text('Change Password'),
            onTap: () {
              // Navigate to change password page
            },
          ),
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: true,
            onChanged: (bool value) {
              // Handle change
            },
          ),
        ],
      ),
    );
  }
}
