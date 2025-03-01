import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'voice_notes_screen.dart';
import 'patient_info_screen.dart';
import 'tasks_screen.dart';
import 'ai_help_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientDialog(context),
        child: const Icon(Icons.add),
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
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('patients').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  var patients = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      var patient = patients[index];
                      return _buildPatientCard(
                        context,
                        patient.id,
                        patient['name'],
                        patient['room'],
                        patient['age'].toString(),
                        patient['status'],
                        Colors.redAccent,
                        patient['diagnosis'],
                        patient['progress'],
                        patient['vitals'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildPatientCard(BuildContext context, String id, String name, String room, String age, String status, Color statusColor, String diagnosis, String progress, String vitals) {
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
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              FirebaseFirestore.instance.collection('patients').doc(id).delete();
            },
          ),
        ),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController diagnosisController = TextEditingController();
    final TextEditingController progressController = TextEditingController();
    final TextEditingController vitalsController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Patient"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: roomController, decoration: const InputDecoration(labelText: 'Room')),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
              TextField(controller: diagnosisController, decoration: const InputDecoration(labelText: 'Diagnosis')),
              TextField(controller: progressController, decoration: const InputDecoration(labelText: 'Progress')),
              TextField(controller: vitalsController, decoration: const InputDecoration(labelText: 'Vitals')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('patients').add({
                  'name': nameController.text,
                  'room': roomController.text,
                  'age': int.parse(ageController.text),
                  'status': 'Stable',
                  'diagnosis': diagnosisController.text,
                  'progress': progressController.text,
                  'vitals': vitalsController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
