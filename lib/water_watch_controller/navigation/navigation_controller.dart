import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../services/user_pref_service.dart';
import '../../water_watch_pages/dashboard.dart';
import '../../water_watch_pages/my_record.dart';
import '../../water_watch_pages/seetings_page.dart';
import '../../water_watch_pages/sms_page.dart';
import '../dashboard/DashboardController.dart';
import '../my_record/my_record_conttroller.dart';

class WaterWatchNavigationController extends GetxController {
  //TODO: Implement HomeController
  static WaterWatchNavigationController get to => Get.find();

  final count = 0.obs;
  var currentTab = 0.obs;
  Widget get currentScreen {
    switch (currentTab.value) {
      case 0:
        return WaterWatchDashboardPage();
      case 1:
        return MyRecordPage();
      case 2:
        return SmsPage();
      case 3:
        return WaterWatchSettingsPage();
      default:
        return WaterWatchDashboardPage();
    }
  }
  final userPrefService = UserPrefService();

  @override
  void onInit() {
    super.onInit();
    //checkLogin();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void onItemTapped(index) {
    currentTab.value = index;
  }

  void changePage(int index) {
    if (index == 0 && Get.isRegistered<WaterWatchDashboardController>()) {
      Get.delete<WaterWatchDashboardController>(force: true);// Delete the controller if it exists, so it reinitialized next time
    }
    if (index == 1 && Get.isRegistered<MyRecordController>()) {
      Get.delete<MyRecordController>(force: true);// Delete the controller if it exists, so it reinitialized next time
    }
    currentTab.value = index;
  }
}
