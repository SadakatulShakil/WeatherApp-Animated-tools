import 'dart:ffi';

import 'package:bmd_weather_app/core/screens/pressure_details_page.dart';
import 'package:bmd_weather_app/core/widgets/wind_and_pressure_widget/pressure_meter.dart';
import 'package:bmd_weather_app/core/widgets/wind_and_pressure_widget/wind_meter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/forecast_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../screens/icon_preference.dart';
import '../../screens/wind_details_page.dart';

class WindAndPressureCards extends StatelessWidget {

  String windSpeedValue;
  String windDirValue;
  double pressureValue;
  WindAndPressureCards(this.windSpeedValue, this.pressureValue, this.windDirValue);

  final ForecastController controller = Get.put(ForecastController());
  final ThemeController themeController = Get.find<ThemeController>();

  String banglaToEnglishNumber(String input) {
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];

    for (int i = 0; i < bangla.length; i++) {
      input = input.replaceAll(bangla[i], english[i]);
    }
    return input;
  }
  final isBangla = Get.locale?.languageCode == 'bn';

  @override
  Widget build(BuildContext context) {

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.only(left: 2, right: 2),
      mainAxisSpacing: 10,
      childAspectRatio: 0.70,
      // <<< Important! Adjust card height!
      children: [
        GestureDetector(
          onTap: () {
            //Get.to(() => WindDetailsPage());
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.white
                  : Color(0xFF3986DD),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.air, color: themeController.themeMode.value == ThemeMode.light
                        ? Colors.black
                        : Colors.white, size: 22),
                    Expanded(
                      child: Text(
                        'wind_title'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ],
                ),
                Expanded(
                  child: WindCompass(
                    windSpeed: isBangla ? double.tryParse(banglaToEnglishNumber(windSpeedValue)) ?? 0.0 : double.tryParse(windSpeedValue) ?? 0.0,
                    windDirection: isBangla ? double.tryParse(banglaToEnglishNumber(windDirValue)) ?? 0.0 : double.tryParse(windDirValue) ?? 0.0, // North
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            //Get.to(() => PressureDetailsPage());
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.white
                  : Color(0xFF3986DD),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.compress, color: themeController.themeMode.value == ThemeMode.light
                        ? Colors.black
                        : Colors.white, size: 22),
                    Expanded(
                      child: Text(
                        'pressure_title'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ],
                ),
                Expanded(child: PressureMeter(pressureValue: pressureValue)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


