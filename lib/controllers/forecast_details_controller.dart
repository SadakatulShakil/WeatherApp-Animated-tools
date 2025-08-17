import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

class ForecastDetailsController extends GetxController {
  var selectedHourTab = 1.obs;
  var selectedDayTab = 0.obs;
  var selectedDay = 0.obs;

  List<String> hourTabs = ['দুপুর ১২.০০', 'দুপুর ০৩.০০', 'বিকাল ০৬.০০', 'রাত ০৯.০০'];

  final fifteenDays = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> forecastData = List.generate(12, (index) => {
    'time': 'বিকাল ০${index}.০০',
    'date': 'শুক্রবার, ১০ এপ্রিল ২০২৫',
    'temperature': '৩১° পরিষ্কার',
    'rainChance': '০%',
    'rainAmount': '০.০ মিলি',
    'humidity': '০.০%',
    'visibility': '০.০ মিনিট',
    'uvIndex': '৪.০০',
    'windSpeed': '১৪কিমি/ঘন্টা',
    'windDirection': 'দক্ষিণ',
    'cloud': '১৫০৫ একরাশ',
  });


  void generateDemoFifteenDays(){
    final now = DateTime.now();

    fifteenDays.value = List.generate(15, (index) {
      final date = now.add(Duration(days: index));
      return {
        'day': DateFormat.E('bn_BD').format(date)+' বার',
      };
    });
  }


  @override
  void onInit() {
    super.onInit();
    generateDemoFifteenDays();
    _setClosestHourTab();
  }

  void _setClosestHourTab() {
    final now = DateTime.now();
    final tabTimes = [12, 15, 18, 21];
    int closest = 0;
    int minDiff = 24;
    for (int i = 0; i < tabTimes.length; i++) {
      int diff = (now.hour - tabTimes[i]).abs();
      if (diff < minDiff) {
        closest = i;
        minDiff = diff;
      }
    }
    selectedHourTab.value = closest;
  }

  void _setCurrentFifteenDay() {
    selectedDay.value = 0; // today
  }
}
