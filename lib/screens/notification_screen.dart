import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Colors.red),
            title: Text("High Priority Alert"),
            subtitle: Text("Patient John Doe requires urgent attention."),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.medical_services, color: Colors.blue),
            title: Text("Medication Reminder"),
            subtitle: Text("Emma Wilson's insulin dose is scheduled for 10:30 PM."),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.green),
            title: Text("Shift Change Update"),
            subtitle: Text("Your night shift has been confirmed for Ward 7."),
          ),
        ],
      ),
    );
  }
}
