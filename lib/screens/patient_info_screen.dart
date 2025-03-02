import 'dart:html' as html; // For web-specific file handling
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart'; // To open files

class PatientInfoScreen extends StatefulWidget {
  final Map<String, String> patient;

  const PatientInfoScreen({super.key, required this.patient});

  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  List<Map<String, String>> vitalsHistory = [];
  List<Map<String, String>> uploadedFiles = [];

  void _addVitals() {
    showDialog(
      context: context,
      builder: (context) {
        String bp = "", sugar = "", temp = "", notes = "";
        return AlertDialog(
          title: const Text("Add Today's Vital"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _textField("Blood Pressure (mmHg)", (val) => bp = val),
              _textField("Sugar Level (mg/dL)", (val) => sugar = val),
              _textField("Temperature (°F)", (val) => temp = val),
              _textField("Medical Notes", (val) => notes = val),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  vitalsHistory.insert(0, {
                    "bp": bp,
                    "sugar": sugar,
                    "temp": temp,
                    "notes": notes,
                    "date": DateTime.now().toString().substring(0, 10),
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.isNotEmpty) {
    PlatformFile file = result.files.first;

    // Convert file bytes to a Blob URL (temporary)
    final blob = html.Blob([file.bytes!]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    setState(() {
      uploadedFiles.add({"name": file.name, "url": url});
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${file.name} uploaded successfully!")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No file selected")),
    );
  }
}



  void _viewFile(String fileUrl) {
  html.window.open(fileUrl, "_blank"); // Opens in a new tab
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient['name'] ?? 'Patient Info'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoBox("🏥 Room", widget.patient['room']),
            _infoBox("📅 Age", widget.patient['age']),
            _infoBox("🩺 Diagnosis", widget.patient['diagnosis']),
            const SizedBox(height: 20),
            const Text("📜 Daily Vitals & Notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            vitalsHistory.isEmpty
                ? const Text("No records yet")
                : Column(children: vitalsHistory.map((vital) => _vitalCard(vital)).toList()),
            const SizedBox(height: 20),
            const Text("📂 Uploaded Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            uploadedFiles.isEmpty
                ? const Text("No files uploaded")
                : Column(children: uploadedFiles.map((file) => _fileCard(file)).toList()),
            ElevatedButton.icon(
              onPressed: _uploadFile,
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Report"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVitals,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoBox(String title, String? value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "$title: ${value ?? 'N/A'}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _vitalCard(Map<String, String> vital) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text("Vitals on ${vital['date']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("BP: ${vital['bp']}, Sugar: ${vital['sugar']}, Temp: ${vital['temp']}°F\nNotes: ${vital['notes']}"),
      ),
    );
  }

  Widget _fileCard(Map<String, String> file) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      leading: const Icon(Icons.insert_drive_file, color: Colors.blueAccent),
      title: Text(file["name"]!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility, color: Colors.green),
            onPressed: () => _viewFile(file["url"]!), // Open file in browser
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                uploadedFiles.remove(file);
              });
            },
          ),
        ],
      ),
    ),
  );
}



  Widget _textField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }
}
