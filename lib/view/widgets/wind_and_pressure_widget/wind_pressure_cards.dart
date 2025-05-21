import 'package:bmd_weather_app/view/widgets/wind_and_pressure_widget/pressure_meter.dart';
import 'package:bmd_weather_app/view/widgets/wind_and_pressure_widget/wind_meter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/forecast_controller.dart';
import '../../screens/icon_preference.dart';

class WindAndPressureCards extends StatelessWidget {
  final ForecastController controller = Get.put(ForecastController());
  double windSpeed = 16.8;
  double pressure = 1002.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        padding: const EdgeInsets.only(left: 4, right: 4),
        mainAxisSpacing: 12,
        childAspectRatio: 0.70,
        // <<< Important! Adjust card height!
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
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
                    Icon(Icons.air, color: Colors.white, size: 22),
                    Expanded(
                      child: Text(
                        'Wind',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
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
              color: Colors.blue.shade400,
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
                    Icon(Icons.compress, color: Colors.white, size: 22),
                    Expanded(
                      child: Text(
                        'Pressure',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
                Expanded(child: PressureMeter(pressureValue: pressure)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


