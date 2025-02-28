import 'package:flutter/material.dart';

class PatientInfoScreen extends StatelessWidget {
  final String name;
  final String room;
  final String age;
  final String status;
  final Color statusColor;

  const PatientInfoScreen({
    super.key,
    required this.name,
    required this.room,
    required this.age,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Room: $room", style: const TextStyle(fontSize: 18)),
            Text("Age: $age", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Status: $status",
                style: TextStyle(fontSize: 18, color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
