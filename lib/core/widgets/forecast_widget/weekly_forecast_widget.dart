import 'package:bmd_weather_app/core/widgets/forecast_widget/temp_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/forecast_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../screens/icon_preference.dart';

class WeeklyForecastView extends StatefulWidget {
  @override
  State<WeeklyForecastView> createState() => _WeeklyForecastViewState();
}

class _WeeklyForecastViewState extends State<WeeklyForecastView> {
  final ForecastController controller = Get.put(ForecastController());

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: themeController.themeMode.value == ThemeMode.light
              ? [Colors.white, Colors.white]
              : [Colors.blue.shade500, Colors.blue.shade500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Forecast, Next 7 days",
              style: TextStyle(
                color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Obx(
                  () => Column(
                children: List.generate(controller.forecastList.length, (index) {
                  final item = controller.forecastList[index];
                  final iconUrl = controller.getIconUrl(item.iconKey);

                  return Column(
                    children: [
                      SizedBox(height: 16,),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${item.day}',
                                  style: TextStyle(
                                    color: themeController.themeMode.value == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${item.date}',
                                  style: TextStyle(
                                    color: themeController.themeMode.value == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Image.asset(iconUrl, width: 25, height: 25),
                          ),
                          Text(
                            '${item.minTemp}°C',
                            style: TextStyle(
                              color: themeController.themeMode.value == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  AnimatedTempIndicator(
                                    rangeFactor: ((item.maxTemp - item.minTemp)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${item.maxTemp}°C',
                              style: TextStyle(
                                color: themeController.themeMode.value == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: themeController.themeMode.value == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


