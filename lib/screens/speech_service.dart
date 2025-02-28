import 'package:flutter/material.dart';
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/speech_to_text.dart';
import 'dart:io';

class SpeechService {
  final SpeechToText speechToText;

  SpeechService({required this.speechToText});

  static Future<SpeechService> create() async {
    final serviceAccount = File('assets/service_account.json'); // Add Google API Key
    final speechToText = await SpeechToText.viaServiceAccount(serviceAccount);
    return SpeechService(speechToText: speechToText);
  }

  Future<String> recognizeSpeech() async {
    final recognition = await speechToText.recognize(
      config: RecognitionConfig(
        encoding: AudioEncoding.linear16,
        sampleRateHertz: 16000,
        languageCode: 'en-US',
      ),
    );
    return recognition.results.first.alternatives.first.transcript;
  }
}
