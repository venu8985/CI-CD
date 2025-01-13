import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if biometric authentication is available
  Future<bool> canAuthenticate() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    print('can chcek biometrcis ${canCheckBiometrics}');
    return canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometricsa() async {
    print('get avalble biometrics${await _localAuth.getAvailableBiometrics()}');
    return await _localAuth.getAvailableBiometrics();
  }

  Future<bool> authenticate() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    getAvailableBiometricsa();
    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        print("No biometrics available on this device.");
        return false;
      }

      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to access this feature',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return isAuthenticated;
    } catch (e) {
      print('Error during authentication: $e');
      return false;
    }
  }

  // Register biometric data and store it in Firestore
  Future<bool> registerBiometric() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Store a flag in Firestore that biometric authentication is registered
        await _firestore.collection('users').doc(user.uid).set({
          'biometricRegistered': true,
        }, SetOptions(merge: true));

        print('Biometric registered for user: ${user.uid}');
        return true;
      }
      return false;
    } catch (e) {
      print('Error registering biometric data: $e');
      return false;
    }
  }

  // Check if biometric authentication is registered in Firestore
  Future<bool> isBiometricRegistered() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists && snapshot.data() != null) {
          return snapshot['biometricRegistered'] ?? false;
        }
      }
      return false;
    } catch (e) {
      print('Error checking biometric registration: $e');
      return false;
    }
  }

  // Login with email and password
  Future<bool> loginWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Register a new user (for email/password registration)
  Future<bool> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Log out the user
  Future<void> logout() async {
    await _auth.signOut();
  }
}
