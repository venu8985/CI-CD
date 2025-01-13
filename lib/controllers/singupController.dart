import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_signin/screens/loginScreen.dart';
import 'package:test_signin/sharedData.dart';

class SignUpController extends GetxController {
  // Fields for user input
  var email = ''.obs;
  var password = ''.obs;

  // Function to store user data in local storage
  void signUp() async {
    final box = LocalStorage();
    final existingUser = await box.getData(email.value);

    // Check if the user already exists
    if (existingUser != null) {
      Get.snackbar('SignUp Failed', 'User already exists');
    } else {
      // Store new user data in local storage (using email as unique key)
      await box.setData(
          email.value, {'email': email.value, 'password': password.value});
      Get.snackbar('SignUp', 'User signed up successfully');
      Get.offAll(LoginScreen());
    }
  }
}
