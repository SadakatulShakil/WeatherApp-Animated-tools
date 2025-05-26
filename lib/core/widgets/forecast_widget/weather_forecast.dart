import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../../controllers/forecast_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/hourly_weather_model.dart';

class WeatherForecastChart extends StatelessWidget {

  final ForecastController controller = Get.put(ForecastController());
  final ThemeController themeController = Get.find<ThemeController>();
  final List<HourlyWeatherModel> demoData = [
    HourlyWeatherModel("00:00", 'moon_cloud', 25.0, 10, 0),
    HourlyWeatherModel("03:00", 'moon_rain', 30.0, 20, 1),
    HourlyWeatherModel("06:00", 'sun_cloud', 38.0, 70, 2),
    HourlyWeatherModel("09:00", 'sun_rain', 24.0, 15, 3),
    HourlyWeatherModel("12:00", 'tornado', 32.0, 5, 4),
    HourlyWeatherModel("15:00", 'moon_cloud', 30.0, 25, 5),
    HourlyWeatherModel("18:00", 'moon_rain', 38.5, 60, 6),
    HourlyWeatherModel("21:00", 'sun_cloud', 25.0, 10, 7),
    HourlyWeatherModel("00:00", 'sun_rain', 32.5, 12, 8),
    HourlyWeatherModel("03:00", 'tornado', 36.0, 30, 9),
    HourlyWeatherModel("06:00", 'moon_cloud', 38.5, 80, 10),
    HourlyWeatherModel("09:00", 'moon_rain', 25.0, 20, 11),
    HourlyWeatherModel("12:00", 'sun_cloud', 28.0, 10, 12),
    HourlyWeatherModel("15:00", 'sun_rain', 35.0, 40, 13),
    HourlyWeatherModel("18:00", 'sun_cloud', 32.5, 55, 14),
    HourlyWeatherModel("21:00", 'tornado', 30.0, 18, 15),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Forecast, Next 72 hours",
              style: TextStyle(
                color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          // Weather forecast chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: demoData.length * 80,
                  child: Stack(
                    children: [
                      LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          minX: -.4,
                          maxX: demoData.length.toDouble() - .5,
                          minY: 12,
                          maxY: 50,
                          lineBarsData: [
                            LineChartBarData(
                              spots:
                              demoData
                                  .map(
                                    (e) => FlSpot(
                                  e.index.toDouble(),
                                  e.temp,
                                ),
                              )
                                  .toList(),
                              color: Colors.transparent,
                              isCurved: true,
                              belowBarData: BarAreaData(
                                gradient: LinearGradient(
                                  colors: themeController.themeMode.value == ThemeMode.light
                                      ? [Colors.grey.shade400, Colors.white]
                                      : [Colors.blue.shade200, Colors.blue.shade500,],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                show: true,
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                    FlDotCirclePainter(
                                      radius: 2,
                                      color: Colors.transparent,
                                      strokeColor: themeController.themeMode.value == ThemeMode.light
                                      ? Colors.blue
                                          :Colors.greenAccent,
                                      // Your desired dot color
                                      strokeWidth: 2.5,
                                    ),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipRoundedRadius: 8,
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((LineBarSpot spot) {
                                  return LineTooltipItem(
                                    '${spot.y.toInt()}°C', // or '${spot.x}, ${spot.y}'
                                    TextStyle(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.black
                                          : Colors.white,       // Text color
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [],
                                    textAlign: TextAlign.center,
                                    // 👇 Background now comes from the tooltip's paint configuration
                                  );
                                }).toList();
                              },
                              tooltipPadding: const EdgeInsets.all(8),
                              tooltipMargin: 12,
                              tooltipBorder: BorderSide.none,
                            ),
                          ),

                        ),
                      ),
                      Positioned.fill(
                        child: Obx(() =>  Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:
                          demoData.map((hour) {
                            final iconUrl = controller.getIconUrl(hour.iconKey);
                            return Expanded(
                              child: Column(
                                children: [
                                  // Time and icon at top
                                  Text(
                                    hour.time,
                                    style: TextStyle(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Image.asset(iconUrl, width: 25, height: 25),
                                  Spacer(),

                                  // Temperature just below dot
                                  Text(
                                    '${hour.temp.toInt()}°C',
                                    style: TextStyle(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),

                                  SizedBox(height: 4),
                                  // Rain chance
                                  Text(
                                    '${hour.rainChance}% ',
                                    style: TextStyle(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.blue
                                          :Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),

                                  // Wind at the bottom
                                  SizedBox(height: 4),
                                  Text(
                                    '${(hour.temp * 0.5).toStringAsFixed(1)} km/h',
                                    style: TextStyle(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
