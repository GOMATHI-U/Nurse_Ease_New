import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, String>> _tasks = [
    {'title': 'Insulin Administration', 'time': '10:30 PM'},
    {'title': 'Vital Signs Check', 'time': '11:00 PM'},
    {'title': 'Medication Reminder', 'time': '11:30 PM'},
  ];

  void _addTask(String title, String time) {
    setState(() {
      _tasks.add({'title': title, 'time': time});
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.task_alt, color: Colors.green),
              title: Text(_tasks[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_tasks[index]['time']!),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_outline, color: Colors.blue),
                onPressed: () => _deleteTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController timeController = TextEditingController();
              return AlertDialog(
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Task Title'),
                    ),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(labelText: 'Time'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addTask(titleController.text, timeController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
