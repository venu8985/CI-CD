import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:test_signin/screens/ml_kit_biometric/bio_auth_service.dart';

class BiometricLoginPage extends StatefulWidget {
  @override
  _BiometricLoginPageState createState() => _BiometricLoginPageState();
}

class _BiometricLoginPageState extends State<BiometricLoginPage> {
  final _auth = FirebaseAuth.instance;
  final _localAuth = LocalAuthentication();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String availableBiometrics = "None"; // Display biometrics type for the user

  // Method to handle login with credentials (email/password)
  Future<void> _loginWithCredentials() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Logged in with credentials: ${userCredential.user?.email}");
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }

  // Method to handle login with fingerprint
  Future<void> _loginWithFingerprint() async {
    try {
      // Check if fingerprint authentication is available
      List<BiometricType> biometrics =
          await _localAuth.getAvailableBiometrics();

      if (biometrics.contains(BiometricType.weak)) {
        bool isAuthenticated = await _localAuth.authenticate(
          localizedReason:
              'Please authenticate to access your account using Fingerprint',
          options: const AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
            biometricOnly: true,
          ),
        );
        if (isAuthenticated) {
          print('Fingerprint authentication successful');
          // Navigator.pushNamed(context, '/home');
        } else {
          print('Fingerprint authentication failed');
        }
      } else {
        print('Fingerprint authentication is not available');
      }
    } catch (e) {
      print('Error during fingerprint authentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fingerprint authentication failed")));
    }
  }

  // Method to handle login with face recognition
  Future<void> _loginWithFaceRecognition() async {
    try {
      // Check if face recognition authentication is available
      AuthService authService = AuthService();
      var biometrics = await authService.getAvailableBiometricsa();
      if (biometrics.contains(BiometricType.strong)) {
        bool isAuthenticated = await _localAuth.authenticate(
          localizedReason:
              'Please authenticate to access your account using Face Recognition',
          options: const AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
            biometricOnly: true,
          ),
        );
        if (isAuthenticated) {
          print('Face recognition authentication successful');
          // Navigator.pushNamed(context, '/home');
        } else {
          print('Face recognition authentication failed');
        }
      } else {
        print('Face recognition is not available');
      }
    } catch (e) {
      print('Error during face recognition authentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Face recognition authentication failed")));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAvailableBiometrics();
  }

  // Method to check available biometrics (face or fingerprint)
  Future<void> _checkAvailableBiometrics() async {
    try {
      List<BiometricType> biometrics =
          await _localAuth.getAvailableBiometrics();

      setState(() {
        if (biometrics.contains(BiometricType.strong)) {
          availableBiometrics = "Face Recognition Available";
        } else if (biometrics.contains(BiometricType.weak)) {
          availableBiometrics = "Fingerprint Available";
        } else {
          availableBiometrics = "No biometric methods available";
        }
      });
    } catch (e) {
      print("Error checking available biometrics: $e");
      setState(() {
        availableBiometrics = "Error checking biometrics";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithCredentials,
              child: Text("Login with Credentials"),
            ),
            SizedBox(height: 10),
            Text("Available Biometrics: $availableBiometrics"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loginWithFingerprint,
              child: Text("Login with Fingerprint"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loginWithFaceRecognition,
              child: Text("Login with Face Recognition"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to RegistrationPage
                Navigator.pushNamed(context, '/register');
              },
              child: Text("Don't have an account? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
