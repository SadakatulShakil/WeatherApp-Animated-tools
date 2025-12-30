import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import '../../../controllers/forecast_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../screens/hourly_forecast_page.dart';

class WeatherForecastChart extends StatelessWidget {
  final ForecastController controller = Get.put(ForecastController());
  final ThemeController themeController = Get.find<ThemeController>();
  final HomeController hController = Get.find<HomeController>();
  var isBangla =  Get.locale?.languageCode == 'bn';
  String englishToBanglaNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bangla  = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], bangla[i]);
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    // Dimensions constant
    final double itemWidth = 80.0;
    final double chartHeight = 320.0;

    return Container(
      height: chartHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: themeController.themeMode.value == ThemeMode.light
              ? [Colors.white, Colors.white]
              : [Color(0xFF3986DD), Color(0xFF3986DD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          GestureDetector(
            //onTap: () => Get.to(() => HourlyForecastDetailsPage()),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    "next_72_hours_forecast".tr,
                    style: TextStyle(
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "details".tr,
                    style: TextStyle(
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Color(0xFF00E5CA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 12,
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Color(0xFF00E5CA))
                ],
              ),
            ),
          ),
          Divider(
            color: themeController.themeMode.value == ThemeMode.light
                ? Colors.grey.shade300
                : Colors.grey.shade500,
            height: 1,
          ),

          // --- REACTIVE CHART AREA ---
          Expanded(
            child: Obx(() {
              // 1. Fetch Data Reactively
              final hourlyForecastData = hController.getHourlyFromSteps();

              // 2. Handle Empty/Loading State
              if (hourlyForecastData.isEmpty) {
                return Center(child: Text("data_load_indicator".tr));
              }

              // 3. Dynamic Y-Axis Calculation (Recalculated on update)
              double minTemp = hourlyForecastData.map((e) => e.temp).reduce(min);
              double maxTemp = hourlyForecastData.map((e) => e.temp).reduce(max);

              // Buffer to prevent clipping
              double minY = minTemp - 2;
              double maxY = maxTemp + 5;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: SizedBox(
                  width: hourlyForecastData.length * itemWidth,
                  child: Stack(
                    children: [
                      // LAYER 1: The Line Chart
                      Padding(
                        padding: const EdgeInsets.only(top: 60, bottom: 60),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            minX: -0.5,
                            maxX: hourlyForecastData.length.toDouble() - 0.5,
                            minY: minY,
                            maxY: maxY,
                            // Tooltip Indicators
                            showingTooltipIndicators: hourlyForecastData.map((e) {
                              return ShowingTooltipIndicators([
                                LineBarSpot(
                                  LineChartBarData(spots: [
                                    FlSpot(e.index.toDouble(), e.temp)
                                  ]),
                                  0, // Bar Index
                                  FlSpot(e.index.toDouble(), e.temp),
                                ),
                              ]);
                            }).toList(),
                            lineBarsData: [
                              LineChartBarData(
                                spots: hourlyForecastData
                                    .map((e) => FlSpot(e.index.toDouble(), e.temp))
                                    .toList(),
                                isCurved: true,
                                curveSmoothness: 0.35,
                                color: Colors.transparent,
                                barWidth: 2,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: themeController.themeMode.value == ThemeMode.light
                                        ? [Colors.grey.shade400, Colors.white]
                                        : [Colors.blue.shade200, Color(0xFF3986DD)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) =>
                                      FlDotCirclePainter(
                                        radius: 2,
                                        color: Colors.transparent,
                                        strokeColor: themeController.themeMode.value == ThemeMode.light
                                            ? Colors.blue
                                            : Colors.greenAccent,
                                        strokeWidth: 2,
                                      ),
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              enabled: false,
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (spot) => Colors.transparent,
                                tooltipPadding: EdgeInsets.zero,
                                tooltipMargin: 8,
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((LineBarSpot spot) {
                                    return LineTooltipItem(
                                      isBangla?
                                      '${englishToBanglaNumber(spot.y.toInt().toString())}°সে'
                                          :'${spot.y.toInt()}°C',
                                      TextStyle(
                                        color: themeController.themeMode.value == ThemeMode.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // LAYER 2: Top Data (Time & Icon)
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: hourlyForecastData.map((data) {
                            return SizedBox(
                              width: itemWidth,
                              child: Column(
                                children: [
                                  Text(
                                    isBangla
                                        ?englishToBanglaNumber(data.time)
                                        :data.time,
                                    style: TextStyle(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.black87
                                          : Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Image.asset(
                                    controller.getIconUrl(data.iconKey),
                                    width: 30,
                                    height: 30,
                                    errorBuilder: (c, e, s) =>
                                        Icon(Icons.sunny, color: Color(0xFF00E5CA)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // LAYER 3: Bottom Data (Rain & Wind)
                      Positioned(
                        bottom: 5,
                        left: 0,
                        right: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: hourlyForecastData.map((data) {
                            return SizedBox(
                              width: itemWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text( isBangla
                                      ?"${englishToBanglaNumber(data.rainAmount.toString())} মিমি"
                                      : "${data.rainAmount} mm",
                                    style: GoogleFonts.anekBangla(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.blue
                                          : Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(isBangla
                                      ?"${englishToBanglaNumber(data.windSpeed.toStringAsFixed(1))} কিমি/ঘণ্টা"
                                      : "${data.windSpeed.toStringAsFixed(1)} km/h",
                                    style: TextStyle(
                                      color: themeController.themeMode.value == ThemeMode.light
                                          ? Colors.black87
                                          : Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          Padding(padding: EdgeInsets.all(10)),
          /// --- FOOTER ---
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Divider(
          //     color: themeController.themeMode.value == ThemeMode.light
          //         ? Colors.grey.shade300
          //         : Color(0xFF00E5CA),
          //     height: 1,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Center(
          //     child: Text(
          //       "",
          //       style: TextStyle(
          //         color: Color(0xFF00E5CA),
          //         fontWeight: FontWeight.bold,
          //         fontSize: 12,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}