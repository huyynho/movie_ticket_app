// setting_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  var selectedLanguage = 'Vietnamese'.obs;
  var isDarkTheme = false.obs;

  // Language list
  final List<String> languages = ['English', 'Vietnamese'];

  void updateLanguage(String language) {
    selectedLanguage.value = language;
    if (language == 'English') {
      Get.updateLocale(Locale('en', 'US'));
    } else if (language == 'Vietnamese') {
      Get.updateLocale(Locale('vi', 'VN'));
    }
  }

  void toggleTheme(bool isDark) {
    isDarkTheme.value = isDark;
    Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());
  }
}
