// setting_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/config/color/color.dart';
import '../../controller/setting_controller.dart';

class SettingScreen extends StatelessWidget {
  final SettingController _controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text('setting'.tr, style: const TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'selectLanguage'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Language Dropdown
            Obx(() {
              return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _controller.selectedLanguage.value,
                  onChanged: (String? newValue) {
                    _controller.updateLanguage(newValue ?? "");
                  },
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: _controller.languages
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Theme Toggle
            Text(
              'Theme'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() {
              return SwitchListTile(
                title: Text('darkTheme'.tr),
                value: _controller.isDarkTheme.value,
                onChanged: (bool value) {
                  _controller.toggleTheme(value);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
