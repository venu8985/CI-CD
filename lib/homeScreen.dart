import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:test_signin/profileController.dart';
import 'package:test_signin/sharedData.dart';
import 'package:test_signin/updateData.dart';

class Homescreen extends GetView<Profilecontroller> {
  Homescreen({super.key});
  final LocalStorage appStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    var fx = Get.put(Profilecontroller());

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Get.delete<Profilecontroller>();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpdateData()));
              },
              child: Text('next')),
          Obx(() {
            return Text("${controller.userData}");
          })
        ],
      ),
    );
  }
}
