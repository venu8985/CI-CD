import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_signin/controllers/singupController.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put(SignUpController()); // Get the controller

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => signUpController.email.value = value,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (value) => signUpController.password.value = value,
            ),
            ElevatedButton(
              onPressed: () {
                signUpController.signUp(); // Call sign-up function
              },
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                // Call sign-up function
              },
              child: Text('login in'),
            ),
          ],
        ),
      ),
    );
  }
}
