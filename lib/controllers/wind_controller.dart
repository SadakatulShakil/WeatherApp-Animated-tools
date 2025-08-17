// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class WindController extends GetxController {
//   var selectedWindDay = 0.obs;
//   final windDays = <Map<String, dynamic>>[].obs;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     generateDemoWindDays();
//
//     _setCurrentWindDay();
//   }
//
//   void generateDemoWindDays() {
//     final now = DateTime.now();
//     final icons = [
//       Icons.sunny,
//       Icons.nights_stay,
//       Icons.air,
//       Icons.sunny,
//       Icons.cloud,
//       Icons.cloudy_snowing,
//       Icons.cloud,
//     ];
//
//     // Create 24 values between 0 and 30 for the brown line (main values)
//     final random = Random();
//     final brownLine = List.generate(24, (i) => (9 + random.nextInt(20)).toDouble());
//
//     // Green line = 60% of brown line
//     final greenLine = brownLine.map((v) => (v * 0.7)).toList();
//
//     windDays.value = List.generate(15, (index) {
//       final date = now.add(Duration(days: index));
//       return {
//         'date': DateFormat('dd/MM').format(date),
//         'day': DateFormat.E('bn_BD').format(date),
//         'icon': icons[index % icons.length],
//         'brown': brownLine,
//         'green': greenLine,
//       };
//     });
//   }
//
//   void _setCurrentWindDay() {
//     selectedWindDay.value = 0; // today
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/wind_day_model.dart';

class WindController extends GetxController {
  var selectedWindDay = 0.obs;
  var windDays = <WindDay>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWindData(); // call API instead of demo
    //_setCurrentWindDay();
  }


  Future<void> fetchWindData() async {
    try {
      // 🔹 Example fake API call (replace with real API)
      await Future.delayed(const Duration(seconds: 1));

      // Example JSON response format

      final List<Map<String, dynamic>> response = List.generate(15, (dayIndex) {
        final date = DateTime.now().add(Duration(days: dayIndex));
        final formattedDate = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}";
        final dayName = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];

        final brownValues = List.generate(24, (i) {
          // Base sine wave between 7 and 17 (amplitude 5, offset 12)
          double value = 12 + 5 * sin((i / 24) * 2 * pi + dayIndex * 0.3);
          return double.parse(value.toStringAsFixed(1)); // optional: round to 1 decimal
        });

        final greenValues = List.generate(24, (i) {
          // Cosine wave slightly lower than brown (amplitude 4, offset 10)
          double value = 10 + 4 * cos((i / 24) * 2 * pi + dayIndex * 0.3);
          return double.parse(value.toStringAsFixed(1));
        });

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

      windDays.value = response.asMap().entries.map((e) {
        final index = e.key;
        final json = e.value;
        return WindDay.fromJson(json, icons[index % icons.length]);
      }).toList();

      selectedWindDay.value = 0;
    } catch (e) {
      print("Error fetching wind data: $e");
    }
  }

  void _setCurrentWindDay() {
    selectedWindDay.value = 0; // today
  }
}
