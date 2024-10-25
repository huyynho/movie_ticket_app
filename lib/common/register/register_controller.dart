import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_auth.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final String errorResult = await FirebaseAuth.createUserWithEmailPassword(
      name: name,
      email: email,
      password: password,
    );
    isLoading.value = false;
    if (errorResult.isNotEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.error,
          message: errorResult,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.success,
          message: CommonMessage.createUserSuccess,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );

      // Get.to(AppRouterName.home);
    }
  }
}
