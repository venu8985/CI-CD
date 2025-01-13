import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_signin/screens/ml_kit_biometric/bio_auth_service.dart';
import 'package:test_signin/screens/ml_kit_biometric/bio_home.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isProcessing = false;
  String _message = '';

  // Register the user with email and password
  void _register() async {
    setState(() {
      _isProcessing = true;
      _message = '';
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isProcessing = false;
        _message = 'Please fill out both fields.';
      });
      return;
    }

    bool success = await _authService.registerUser(email, password);
    if (success) {
      // Proceed to biometric registration only after successful user registration
      _handleBiometricRegistration();
    } else {
      setState(() {
        _isProcessing = false;
        _message = 'Registration failed, try again.';
      });
    }
  }

  // Register biometric data for the user
  void _handleBiometricRegistration() async {
    bool isAvailable = await _authService.authenticate();
    if (isAvailable) {
      bool isRegistered = await _authService.registerBiometric();
      if (isRegistered) {
        setState(() {
          _isProcessing = false;
          _message = 'Biometric registered successfully!';
        });

        // Proceed to home screen after biometric registration
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _isProcessing = false;
          _message = 'Failed to register biometric data.';
        });
      }
    } else {
      setState(() {
        _isProcessing = false;
        _message = 'Biometric authentication is not available on this device.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : _register,
              child: _isProcessing
                  ? CircularProgressIndicator()
                  : Text('Register and Setup Biometric'),
            ),
            SizedBox(height: 20),
            if (_message.isNotEmpty) Text(_message),
          ],
        ),
      ),
    );
  }
}
