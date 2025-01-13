import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:test_signin/sharedData.dart';

class Profilecontroller extends GetxController {
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxMap<dynamic, dynamic> userData = {}.obs;
  Rx<TextEditingController> contoller = TextEditingController().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    updateData();
  }

  void updateData() async {
    email.value = await LocalStorage().getData('myEmail');
    userData.value = await LocalStorage().getData(email.value);
    print(userData.value);
  }
}
