import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:test_signin/profileController.dart';
import 'package:test_signin/sharedData.dart';

class UpdateData extends GetView {
  UpdateData({super.key});
  final LocalStorage appStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    var fx = Get.put(Profilecontroller());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            return TextField(
              controller: fx.contoller.value,
              // onChanged: (value) {
              //   fx.name.value = value.toString();
              // },
            );
          }),
          ElevatedButton(
              onPressed: () async {
                appStorage.setData('name', fx.contoller.value.text);
                print(await appStorage.getData(
                  'name',
                ));
                fx.updateData();
              },
              child: Text('update')),
          Obx(() {
            return Text("${fx.name.value}");
          })
        ],
      ),
    );
  }
}
