import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_signin/screens/ml_kit_face/face_login.dart';
import 'package:test_signin/screens/ml_kit_face/login_screen.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginPage();
    } else {
      return FaceLoginPage();
    }
  }
}
