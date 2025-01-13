import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_signin/homeScreen.dart';
import 'package:test_signin/screens/ml_kit_face/ml_home.dart';

class FaceLoginPage extends StatefulWidget {
  @override
  _FaceLoginPageState createState() => _FaceLoginPageState();
}

class _FaceLoginPageState extends State<FaceLoginPage> {
  final picker = ImagePicker();
  final faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(enableClassification: true, enableContours: true),
  );

  String result = '';
  bool isProcessing = false;
  bool isRegisterMode = false;

  Future<void> handleFaceAuth() async {
    setState(() {
      isProcessing = true;
    });

    try {
      // Pick an image from the camera
      final image = await picker.pickImage(
        preferredCameraDevice: CameraDevice.front,
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1280,
        maxHeight: 720,
      );

      if (image == null) {
        setState(() {
          result = "No image selected";
          isProcessing = false;
        });
        return;
      }

      final inputImage = InputImage.fromFile(File(image.path));
      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          result = "No face detected. Try again!";
          isProcessing = false;
        });
        return;
      }

      // Handle face registration or login based on mode
      if (isRegisterMode) {
        await _registerFace(faces.first, image);
      } else {
        await _loginWithFace(faces.first, image);
      }
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> _registerFace(Face face, XFile image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final imageFile = File(image.path);
        final decodedImage =
            await decodeImageFromList(imageFile.readAsBytesSync());

        // Normalize bounding box coordinates
        final normalizedBoundingBox = {
          'left': face.boundingBox.left / decodedImage.width,
          'top': face.boundingBox.top / decodedImage.height,
          'right': face.boundingBox.right / decodedImage.width,
          'bottom': face.boundingBox.bottom / decodedImage.height,
        };

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'faceData': normalizedBoundingBox,
        });

        setState(() {
          result = "Face registered successfully!";
        });
      } else {
        setState(() {
          result = "User not logged in. Please sign up first.";
        });
      }
    } catch (e) {
      setState(() {
        result = "Error during registration: $e";
      });
    }
  }

  Future<void> _loginWithFace(Face face, XFile image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        print('faced data in firebase==============');
        print(doc['faceData']);

        if (doc.exists) {
          final storedBoundingBox = Map<String, double>.from(doc['faceData']);
          final imageFile = File(image.path);
          final decodedImage =
              await decodeImageFromList(imageFile.readAsBytesSync());

          // Normalize the detected face bounding box
          final normalizedBoundingBox = {
            'left': face.boundingBox.left / decodedImage.width,
            'top': face.boundingBox.top / decodedImage.height,
            'right': face.boundingBox.right / decodedImage.width,
            'bottom': face.boundingBox.bottom / decodedImage.height,
          };

          const double tolerance = 0.1; // Adjust tolerance as needed
          if (_areBoundingBoxesSimilar(
              storedBoundingBox, normalizedBoundingBox, tolerance)) {
            setState(() {
              result = "Face matched. Logging in...";
            });
            print("Face matched. Logging in..");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MlHome()));
            // Navigator.pushReplacementNamed(context, '/home');
          } else {
            setState(() {
              result = "Face not recognized. Please try again.";
            });
          }
        } else {
          setState(() {
            result = "No face data found. Please register first.";
          });
        }
      } else {
        setState(() {
          result = "User not logged in. Please sign up first.";
        });
      }
    } catch (e) {
      setState(() {
        result = "Error during login: $e";
      });
    }
  }

  bool _areBoundingBoxesSimilar(Map<String, double> stored,
      Map<String, double> detected, double tolerance) {
    print('detcted ${detected}');
    print('stored ${stored}');

    // Calculate the center for both stored and detected bounding boxes
    double storedCenterX = (stored['left']! + stored['right']!) / 2;
    double storedCenterY = (stored['top']! + stored['bottom']!) / 2;
    double detectedCenterX = (detected['left']! + detected['right']!) / 2;
    double detectedCenterY = (detected['top']! + detected['bottom']!) / 2;

    // Calculate the distance between the centers
    double centerDistanceX = (storedCenterX - detectedCenterX).abs();
    double centerDistanceY = (storedCenterY - detectedCenterY).abs();
    print('centerDistanceX ${centerDistanceX}');
    print('centerDistanceY ${centerDistanceY}');
    // Use a more generous tolerance (try 0.15 or higher)
    const double tolerance = 0.1;

    // Compare the distances with tolerance
    return centerDistanceX <= tolerance && centerDistanceY <= tolerance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegisterMode ? "Face Registration" : "Face Login"),
        actions: [
          Switch(
            value: isRegisterMode,
            onChanged: (value) {
              setState(() {
                isRegisterMode = value;
                result = '';
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isProcessing) CircularProgressIndicator(),
            Text(result),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleFaceAuth,
              child: Text(isRegisterMode ? 'Register Face' : 'Login with Face'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }
}
