import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app_name.dart';
import 'app/injection_container.dart';
import 'core/services/logger/logger_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('Firebase initialized', 'Main');
  } catch (e) {
    AppLogger.error('Firebase initialization failed', 'Main', e);
  }
  await initDependencies();
  runApp(const HisabKitabApp());
}