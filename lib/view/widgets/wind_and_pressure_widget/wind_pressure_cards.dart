import 'package:bmd_weather_app/view/widgets/wind_and_pressure_widget/pressure_meter.dart';
import 'package:bmd_weather_app/view/widgets/wind_and_pressure_widget/wind_meter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/forecast_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../screens/icon_preference.dart';

class WindAndPressureCards extends StatelessWidget {
  final ForecastController controller = Get.put(ForecastController());
  final ThemeController themeController = Get.find<ThemeController>();
  double windSpeed = 16.8;
  double pressure = 1002.0;
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.themeMode.value == ThemeMode.light
                ? Colors.white
                : Colors.blue.shade400,
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
                      'Wind',
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
                  windSpeed: windSpeed,
                  windDirection: 0, // North
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.themeMode.value == ThemeMode.light
                ? Colors.white
                : Colors.blue.shade400,
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
                      'Pressure',
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
              Expanded(child: PressureMeter(pressureValue: pressure)),
            ],
          ),
        ),
      ],
    );
  }
}


