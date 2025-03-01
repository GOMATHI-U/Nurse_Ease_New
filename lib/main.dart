import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/dashboard_screen.dart';

// Firebase initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCJ4lqQ2Vpj_kGBO1z3xHFIUS-KIQzaWak",
      authDomain: "nurse-ease-fire.firebaseapp.com",
      projectId: "nurse-ease-fire",
      storageBucket: "nurse-ease-fire.firebasestorage.app",
      messagingSenderId: "1265015426",
      appId: "1:1265015426:web:fa91cd0d5e05701cf8729b",
    ),
  );
  print("✅ Firebase successfully connected!");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }
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
        '/': (context) => const DashboardScreen(),
        //'/patientInfo': (context) => PatientInfoScreen(),
        //'/voiceNotes': (context) => VoiceNotesScreen(),
      },
    );
  }
}
