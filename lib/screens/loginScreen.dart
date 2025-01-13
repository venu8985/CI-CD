import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_signin/controllers/loginController.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController()); // Get the controller

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => loginController.email.value = value,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (value) => loginController.password.value = value,
            ),
            ElevatedButton(
              onPressed: () {
                loginController.login(); // Call login function
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
