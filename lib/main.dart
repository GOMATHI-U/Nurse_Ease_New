import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
//import 'screens/patient_info_screen.dart';
//import 'screens/voice_notes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Nursing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardScreen(),
        //'/patientInfo': (context) => PatientInfoScreen(),
        //'/voiceNotes': (context) => VoiceNotesScreen(),
      },
    );
  }
}