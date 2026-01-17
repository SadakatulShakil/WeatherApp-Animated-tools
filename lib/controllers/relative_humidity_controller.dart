import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'home_controller.dart';
import '../models/weather_ui_model.dart';

class RelativeHumidityController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();

  var humidityDays = <WeatherUiModel>[].obs;
  var selectedHumidityDay = 0.obs;

  bool get isBangla => Get.locale?.languageCode == 'bn';

  @override
  void onInit() {
    super.onInit();
    ever(_homeController.forecast, (_) => processHumidityData());
    processHumidityData();
  }

  // --- NEW HELPER: Normalize Bangla Digits to English for Parsing ---
  String _normalizeToEnglish(String value) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    String temp = value;
    for (int i = 0; i < 10; i++) {
      temp = temp.replaceAll(bn[i], en[i]);
    }
    return temp;
  }

  void processHumidityData() {
    final steps = _homeController.forecast.value?.result?.steps;

    if (steps == null || steps.isEmpty) {
      humidityDays.clear();
      return;
    }

    Map<String, List<ChartPoint>> groupedPoints = {};
    Map<String, dynamic> dayInfo = {};

    for (var step in steps) {
      if (step.stepStart == null) continue;

      try {
        String formattedDate = step.stepStart!.replaceAll(' ', 'T');
        DateTime dt = DateTime.parse(formattedDate);
        String dateKey = DateFormat('yyyy-MM-dd').format(dt);

        double speed = 0.0;
        if (step.rh?.valAvg != null) {
          // STEP 1: Normalize the string before parsing
          String rawValue = step.rh!.valAvg!;
          String englishValue = _normalizeToEnglish(rawValue);

          // STEP 2: Calculation Task (Parsing works now!)
          speed = double.tryParse(englishValue) ?? 0.0;
        }

        if (!groupedPoints.containsKey(dateKey)) {
          groupedPoints[dateKey] = [];
          dayInfo[dateKey] = {
            "dateDisplay": DateFormat('dd MMM').format(dt),
            "dayName": step.weekday ?? DateFormat('EEEE').format(dt),
          };
        }

        groupedPoints[dateKey]!.add(ChartPoint(dt.hour.toDouble(), speed));
      } catch (e) {
        print("WIND_LOG: Error in loop: $e");
      }
    }

    List<WeatherUiModel> tempList = [];
    var sortedKeys = groupedPoints.keys.toList()..sort();

    for (var key in sortedKeys) {
      var points = groupedPoints[key]!;
      points.sort((a, b) => a.x.compareTo(b.x));

      // Calculate Min/Max (Task done in English doubles)
      double min = points.isEmpty ? 0 : points.map((e) => e.y).reduce((a, b) => a < b ? a : b);
      double max = points.isEmpty ? 0 : points.map((e) => e.y).reduce((a, b) => a > b ? a : b);

      tempList.add(WeatherUiModel(
        dateRaw: key,
        dateDisplay: _formatDate(dayInfo[key]['dateDisplay']),
        dayName: _translateDay(dayInfo[key]['dayName']),
        points: points,
        minVal: min,
        maxVal: max,
        avgVal: points.isEmpty ? 0 : points.map((e) => e.y).reduce((a, b) => a + b) / points.length,
      ));
    }

    humidityDays.assignAll(tempList);
  }


  // Helper for Date display (DD Month)
  String _formatDate(String dateStr) {
    bool isBangla = Get.locale?.languageCode == 'bn';
    if (!isBangla) return dateStr;

    // Splits "17 Jan" into ["17", "Jan"]
    var parts = dateStr.split(' ');
    if (parts.length < 2) return dateStr;

    String day = toBanglaNumber(parts[0]);
    String month = _translateMonth(parts[1]);
    return "$day $month";
  }

  // Simplified logic for number conversion
  String toBanglaNumber(String value) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    for (int i = 0; i < en.length; i++) {
      value = value.replaceAll(en[i], bn[i]);
    }
    return value;
  }

  String _translateMonth(String month) {
    if (!isBangla) return month;
    final months = {
      'Jan': 'জানু', 'Feb': 'ফেব্রু', 'Mar': 'মার্চ', 'Apr': 'এপ্রিল',
      'May': 'মে', 'Jun': 'জুন', 'Jul': 'জুলাই', 'Aug': 'আগস্ট',
      'Sep': 'সেপ্টেম্বর', 'Oct': 'অক্টোবর', 'Nov': 'নভেম্বর', 'Dec': 'ডিসেম্বর'
    };
    return months[month] ?? month;
  }

  String _translateDay(String day) {
    if (!isBangla) return day;
    final days = {
      'Saturday': 'শনিবার', 'Sunday': 'রবিবার', 'Monday': 'সোমবার',
      'Tuesday': 'মঙ্গলবার', 'Wednesday': 'বুধবার', 'Thursday': 'বৃহস্পতিবার', 'Friday': 'শুক্রবার'
    };
    return days[day] ?? day;
  }
}