import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
// Import your HomeController
import '../controllers/home_controller.dart';

class SettingsController extends GetxController {
  RxList<bool> selectedLanguage = [false, true].obs; // Default Bangla
  final userService = UserPrefService();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadLanguagePreference();
    });
  }

  Future<void> changeLanguage(int index) async {
    selectedLanguage.value = [index == 0, index == 1];

    // 1. Determine Language Code
    final langCode = index == 0 ? 'en' : 'bn';

    // 2. Save to preferences
    await UserPrefService().saveAppLanguage(langCode);

    print('saved language: $langCode');

    // 3. Update Locale (This updates UI static strings)
    await Get.updateLocale(Locale(langCode));

    // 4. Trigger API Refresh in HomeController
    // We check if HomeController is registered to avoid errors if the user
    // hasn't visited the home screen yet (unlikely, but good practice).
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();

      // We call the forecast method using the currently stored lat/lon
      // in the HomeController.
      if (homeController.lat.value.isNotEmpty && homeController.lon.value.isNotEmpty) {
        print("🔄 Language changed to $langCode. Refreshing Forecast...");
        await homeController.getForecast(
            homeController.lat.value,
            homeController.lon.value
        );
      }
    }
  }

  Future<void> logout() async {
    await userService.clearUserData();
    // Your logout logic
  }

  Future<void> loadLanguagePreference() async {
    final langCode = UserPrefService().appLanguage;
    selectedLanguage.value = [langCode == 'en', langCode == 'bn'];
    await Get.updateLocale(Locale(langCode));
  }
}