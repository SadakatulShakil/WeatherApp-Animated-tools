import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/rain_day_model.dart';
import '../models/wind_day_model.dart';

class RainController extends GetxController {
  var selectedRainyDay = 0.obs;
  var rainDays = <RainDay>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRainData(); // call API instead of demo
    //_setCurrentWindDay();
  }


  Future<void> fetchRainData() async {
    try {
      // Example fake API call (replace with real API)
      await Future.delayed(const Duration(seconds: 1));

      // Example JSON response format

      final List<Map<String, dynamic>> response = List.generate(15, (dayIndex) {
        final date = DateTime.now().add(Duration(days: dayIndex));
        final formattedDate = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}";
        final dayName = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];

        // // Example variation for each day
        final brownValues = [
          10 + dayIndex, 7 + dayIndex, 9 + dayIndex, 9 + dayIndex, 9 + dayIndex, 8 + dayIndex,
          9 + dayIndex, 10 + dayIndex, 7 + dayIndex, 7 + dayIndex, 10 + dayIndex, 9 + dayIndex,
          9  + dayIndex,  11 + dayIndex,  11 + dayIndex,  9 + dayIndex,  8 + dayIndex,  9 + dayIndex,
          10 + dayIndex, 9 + dayIndex, 10 + dayIndex, 11 + dayIndex, 11 + dayIndex, 9 + dayIndex,
        ];
        // Example variation for each day
        final greenValues = [
          9 + dayIndex, 11 + dayIndex, 11 + dayIndex, 11 + dayIndex, 12 + dayIndex, 13 + dayIndex,
          10 + dayIndex, 14 + dayIndex, 11 + dayIndex, 15 + dayIndex, 9 + dayIndex, 11 + dayIndex,
          11  + dayIndex,  12 + dayIndex,  13 + dayIndex,  12 + dayIndex,  11 + dayIndex,  11 + dayIndex,
          9 + dayIndex, 10 + dayIndex, 11 + dayIndex, 12 + dayIndex, 14 + dayIndex, 12 + dayIndex,
        ];

        // final brownValues = List.generate(24, (i) {
        //   // Base sine wave between 7 and 17 (amplitude 5, offset 12)
        //   double value = 12 + 5 * sin((i / 24) * 2 * pi + dayIndex * 0.3);
        //   return double.parse(value.toStringAsFixed(1)); // optional: round to 1 decimal
        // });
        //
        // final greenValues = List.generate(24, (i) {
        //   // Cosine wave slightly lower than brown (amplitude 4, offset 10)
        //   double value = 10 + 4 * cos((i / 24) * 2 * pi + dayIndex * 0.3);
        //   return double.parse(value.toStringAsFixed(1));
        // });

        return {
          "date": formattedDate,
          "day": dayName,
          "brown": brownValues,
          "green": greenValues,
        };
      });


      final icons = [
        Icons.sunny,
        Icons.cloud,
        Icons.air,
        Icons.cloudy_snowing,
      ];

      rainDays.value = response.asMap().entries.map((e) {
        final index = e.key;
        final json = e.value;
        return RainDay.fromJson(json, icons[index % icons.length]);
      }).toList();

      selectedRainyDay.value = 0;
    } catch (e) {
      print("Error fetching wind data: $e");
    }
  }

}