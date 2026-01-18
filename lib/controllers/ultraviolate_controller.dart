import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UltraviolateRayController extends GetxController {
  var selectedRayDay = 0.obs;
  final rayDays = <Map<String, dynamic>>[].obs;


  final isBangla = Get.locale?.languageCode == 'bn';
  @override
  void onInit() {
    super.onInit();
    generateDemoUltraviolateDays();

    _setCurrentUltraviolateDay();
  }

  void generateDemoUltraviolateDays() {
    final now = DateTime.now();
    final icons = [
      Icons.sunny,
      Icons.nights_stay,
      Icons.air,
      Icons.sunny,
      Icons.cloud,
      Icons.cloudy_snowing,
      Icons.cloud,
    ];

    final random = Random();

    rayDays.value = List.generate(15, (index) {
      final date = now.add(Duration(days: index));

      // Generate heatmap values (0-4)
      final values = List.generate(15, (_) => (random.nextDouble() * 30).toDouble());

      return {
        'date': DateFormat('dd/MM').format(date),
        'day': isBangla?'${DateFormat.E('bn_BD').format(date)}বার':'${DateFormat.E().format(date)}day',
        'icon': icons[index % icons.length],
        'values': values,
      };
    });
  }

  void _setCurrentUltraviolateDay() {
    selectedRayDay.value = 0; // today
  }
}