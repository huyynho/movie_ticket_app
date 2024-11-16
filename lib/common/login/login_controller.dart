import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_auth.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = false;
    final String errorResult = await FirebaseAuth.signInWithEmailPassword(
        email: email, password: password);
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
          message: CommonMessage.loginSuccess,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );

      final user = await FirebaseAuth.getUser();
      if (user != null) {
        if (user.role == 'admin') {
          Get.toNamed(AppRouterName.report);
        } else {
          Get.toNamed(AppRouterName.home);
        }
      } else {
        Get.toNamed(AppRouterName.home);
      }
    }
  }
}
