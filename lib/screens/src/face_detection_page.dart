// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class FaceDetectionPage extends StatefulWidget {
//   @override
//   _FaceDetectionPageState createState() => _FaceDetectionPageState();
// }

// class _FaceDetectionPageState extends State<FaceDetectionPage> {
//   final picker = ImagePicker();
//   final faceDetector = GoogleMlKit.vision.faceDetector(
//     FaceDetectorOptions(enableClassification: true, enableContours: true),
//   );

//   String result = '';

//   Future<void> detectFaces() async {
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);

//     if (image != null) {
//       final inputImage = InputImage.fromFilePath(image.path);

//       final List<Face> faces = await faceDetector.processImage(inputImage);

//       setState(() {
//         result = 'Detected ${faces.length} faces';
//       });

//       for (Face face in faces) {
//         print('Bounding Box: ${face.boundingBox}');
//         if (face.smilingProbability != null) {
//           print('Smile Probability: ${face.smilingProbability}');
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Face Detection')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(result),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: detectFaces,
//               child: Text('Detect Faces'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     faceDetector.close();
//     super.dispose();
//   }
// }
