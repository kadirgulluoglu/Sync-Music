import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RootApp(),
  ));
}
