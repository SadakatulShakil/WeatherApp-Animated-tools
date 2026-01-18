import 'dart:math';

import 'package:bmd_weather_app/models/pressure_day_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class PressureController extends GetxController {
  var selectedWindDay = 0.obs;
  var pressureDay = <PressureDay>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPressureData(); // call API instead of demo
  }


  Future<void> fetchPressureData() async {
    try {
      // 🔹 Example fake API call (replace with real API)
      await Future.delayed(const Duration(seconds: 1));

      // Example JSON response format

      final List<Map<String, dynamic>> response = List.generate(15, (dayIndex) {
        final date = DateTime.now().add(Duration(days: dayIndex));
        final formattedDate = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}";
        final dayName = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][date.weekday - 1];

        // Example variation for each day
        final brownValues = [
          1020 + dayIndex, 1070 + dayIndex, 1100 + dayIndex, 1120 + dayIndex, 1140 + dayIndex, 1150 + dayIndex,
          1130 + dayIndex, 1100 + dayIndex, 1070 + dayIndex, 1040 + dayIndex, 1020 + dayIndex, 1000 + dayIndex,
          950  + dayIndex,  920 + dayIndex,  900 + dayIndex,  920 + dayIndex,  950 + dayIndex,  980 + dayIndex,
          1020 + dayIndex, 1050 + dayIndex, 1080 + dayIndex, 1100 + dayIndex, 1120 + dayIndex, 1140 + dayIndex,
        ];

        return {
          "date": formattedDate,
          "day": dayName,
          "brown": brownValues,
        };
      });

      final icons = [
        Icons.sunny,
        Icons.cloud,
        Icons.air,
        Icons.cloudy_snowing,
      ];

      pressureDay.value = response.asMap().entries.map((e) {
        final index = e.key;
        final json = e.value;
        return PressureDay.fromJson(json, icons[index % icons.length]);
      }).toList();

      selectedWindDay.value = 0;
    } catch (e) {
      print("Error fetching wind data: $e");
    }
  }
}
