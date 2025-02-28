import 'package:flutter/material.dart';
import 'voice_notes_screen.dart';
import 'patient_info_screen.dart';
import 'tasks_screen.dart';
import 'ai_help_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nursing Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, Sarah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Night Shift · Ward 7', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShortcut(context, Icons.mic_none, 'Voice Notes', Colors.blue, const VoiceNotesScreen()),
                _buildShortcut(context, Icons.check_circle_outline, 'Tasks', Colors.green, const TasksScreen()),
                _buildShortcut(context, Icons.chat_bubble_outline, 'AI Help', Colors.orange, const AIHelpScreen()),
              ],
            ),
            const SizedBox(height: 20),
            const Text('My Patients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildPatientCard(context, 'John Doe', '701', '65', 'High Priority', Colors.redAccent, "Diabetes", "Improving", "BP: 130/85, HR: 78bpm"),
            _buildPatientCard(context, 'Emma Wilson', '702', '45', 'Stable', Colors.greenAccent, "Hypertension", "Stable condition", "BP: 120/80, HR: 72bpm"),
            const SizedBox(height: 20),
            const Text('Upcoming Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTaskCard('Insulin Administration', '701', 'John Doe', '10:30 PM', Icons.medical_services),
            _buildTaskCard('Vital Signs Check', '702', 'Emma Wilson', '11:00 PM', Icons.favorite_border),
          ],
        ),
      ),
    );
  }

  /// Widget for Navigation Shortcuts
  Widget _buildShortcut(BuildContext context, IconData icon, String label, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            radius: 25,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Widget for Patient Cards (Clickable)
  Widget _buildPatientCard(BuildContext context, String name, String room, String age, String status, Color statusColor, String diagnosis, String progress, String vitals) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientInfoScreen(
              name: name,
              room: room,
              age: age,
              status: status,
              statusColor: statusColor,
              diagnosis: diagnosis,
              progress: progress,
              vitals: vitals,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Room $room · Age $age'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  /// Widget for Task Cards
  Widget _buildTaskCard(String title, String room, String patient, String time, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Room $room · $patient · $time'),
      ),
    );
  }
}
