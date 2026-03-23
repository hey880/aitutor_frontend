import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');

    // Initialize notification service
    await NotificationService.instance.init();
    print('Notification service initialized successfully');
  } catch (e) {
    print('Error during initialization: $e');
  }

  runApp(const LingoDashApp());
}
