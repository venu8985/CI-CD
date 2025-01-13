import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_signin/bloc/post_data_ui.dart';
import 'package:test_signin/screens/ml_kit_biometric/bio_auth_service.dart';
import 'package:test_signin/screens/ml_kit_biometric/bio_home.dart';
import 'package:test_signin/screens/ml_kit_biometric/bio_registartion.dart';
import 'package:test_signin/screens/ml_kit_biometric/biometric_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometric Authentication with Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostUiData(),
    );
  }
}
