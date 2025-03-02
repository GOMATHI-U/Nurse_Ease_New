import 'package:flutter/material.dart';
import 'voice_notes_screen.dart';
import 'patient_info_screen.dart';
import 'tasks_screen.dart';
import 'ai_help_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, String>> patients = [
    {
      'name': 'John Doe',
      'room': '101',
      'age': '65',
      'diagnosis': 'Hypertension',
      
    },
    {
      'name': 'Alice Smith',
      'room': '102',
      'age': '72',
      'diagnosis': 'Diabetes',
      
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, Sarah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NotificationScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
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
                _buildShortcut(context, Icons.mic_none, 'Voice Notes', Colors.blue,
                    const VoiceNotesScreen()),
                _buildShortcut(context, Icons.check_circle_outline, 'Tasks', Colors.green,
                    const TasksScreen()),
                _buildShortcut(context, Icons.chat_bubble_outline, 'AI Help', Colors.orange,
                    const AIHelpScreen()),
              ],
            ),
            const SizedBox(height: 20),
            const Text('My Patients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: patients.isEmpty
                  ? const Center(child: Text("No patients found."))
                  : ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        return _buildPatientCard(context, index, patients[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcut(
      BuildContext context, IconData icon, String label, Color color, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => screen)),
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

  Widget _buildPatientCard(BuildContext context, int index, Map<String, String> patient) {
    return Card(
      child: ListTile(
        title: Text(patient['name'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Room ${patient['room']} · Age ${patient['age']}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              patients.removeAt(index);
            });
          },
        ),
        onTap: () {
          print("Navigating to PatientInfoScreen with data: ${patient.toString()}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientInfoScreen(patient: Map.from(patient)),
            ),
          );
        },
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final roomController = TextEditingController();
    final ageController = TextEditingController();
    final diagnosisController = TextEditingController();
    final progressController = TextEditingController();
    final bpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Patient"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: roomController, decoration: const InputDecoration(labelText: 'Room')),
                TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
                TextField(controller: diagnosisController, decoration: const InputDecoration(labelText: 'Diagnosis')),
        
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || roomController.text.isEmpty || ageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all required fields!")),
                  );
                  return;
                }

                setState(() {
                  patients = List.from(patients)..add({
                    'name': nameController.text,
                    'room': roomController.text,
                    'age': ageController.text,
                    'diagnosis': diagnosisController.text,
                    
                  });
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
