// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MapScreen(),
//     );
//   }
// }

// //AIzaSyDthgB7q34RmM6TUlHCxezd29jte6Rb0pQ
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;
//   final Map<String, Marker> markers = {};
//   double lat = 37.7749;
//   double lng = -122.4194;

//   @override
//   void initState() {
//     super.initState();
//     _addInitialMarker();
//   }

//   void _addInitialMarker() {
//     markers["1"] = Marker(
//       markerId: MarkerId("1"),
//       position: LatLng(lat, lng),
//       draggable: true,
//       infoWindow: const InfoWindow(
//         title: 'You are here',
//       ),
//       icon: BitmapDescriptor.defaultMarker,
//     );
//   }

//   void _updatePosition(CameraPosition _position) {
//     setState(() {
//       markers["1"] = markers["1"]!.copyWith(
//         positionParam: LatLng(
//           _position.target.latitude,
//           _position.target.longitude,
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Google Maps"),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 Container(
//                   height: 600,
//                   width: double.infinity,
//                   color: Colors.red,
//                 ),
//                 Container(
//                   height: 300,
//                   width: double.infinity,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 300,
//               child: GoogleMap(
//                 mapType: MapType.hybrid,
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(lat, lng),
//                   zoom: 5,
//                 ),
//                 markers: markers.values.toSet(),
//                 onCameraMove: _updatePosition,
//                 onMapCreated: (GoogleMapController controller) {
//                   mapController = controller;
//                 },
//                 gestureRecognizers: {
//                   Factory<OneSequenceGestureRecognizer>(
//                     () => EagerGestureRecognizer(),
//                   ),
//                 },
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 Container(
//                   height: 600,
//                   width: double.infinity,
//                   color: Colors.red,
//                 ),
//                 Container(
//                   height: 300,
//                   width: double.infinity,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
