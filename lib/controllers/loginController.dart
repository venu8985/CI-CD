import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_signin/homeScreen.dart';
import 'package:test_signin/sharedData.dart';

class LoginController extends GetxController {
  // Fields for login input
  var email = ''.obs;
  var password = ''.obs;

  // Function to login
  void login() async {
    final box = LocalStorage();
    final user = await box.getData(email.value);

    // Check if the user exists and password matches
    if (user != null && user['password'] == password.value) {
      await box.setData('myEmail', user['email']);
      Get.snackbar('Login', 'Login successful');
      Get.offAll(Homescreen()); // Navigate to the Home Screen
    } else {
      Get.snackbar('Login Failed', 'Invalid credentials');
    }
  }
}
