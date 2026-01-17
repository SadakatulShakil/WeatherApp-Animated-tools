import 'package:bmd_weather_app/controllers/wind_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/humidity_controller.dart';


class HumidityDetailsPage extends StatefulWidget {
  @override
  State<HumidityDetailsPage> createState() => _HumidityDetailsPageState();
}

class _HumidityDetailsPageState extends State<HumidityDetailsPage> {
  // Ensure the controller name matches your actual HumidityController
  final HumidityController controller = Get.put(HumidityController());

  String toBanglaNumber(num value) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯', '.'];
    String str = value.toStringAsFixed(1);
    for (int i = 0; i < en.length; i++) {
      str = str.replaceAll(en[i], bn[i]);
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: const Text('আর্দ্রতা'), // Corrected Spelling
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.humidityDays.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final currentDay = controller.humidityDays[controller.selectedHumidityDay.value];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Horizontal Day Selector
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.humidityDays.length,
                      itemBuilder: (context, index) {
                        final item = controller.humidityDays[index];
                        final isSelected = controller.selectedHumidityDay.value == index;

                        return GestureDetector(
                          onTap: () => controller.selectedHumidityDay.value = index,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 70,
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.dateDisplay, style: const TextStyle(color: Colors.white, fontSize: 11)),
                                Text(item.dayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${toBanglaNumber(currentDay.minVal)}% – ${toBanglaNumber(currentDay.maxVal)}%",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        const Text(
                          'বাতাসের আপেক্ষিক আর্দ্রতা',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // LINE CHART FOR HUMIDITY
                        SizedBox(
                          height: 250,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: 100,
                              minX: 0,
                              maxX: 21, // Last hour 21:00
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 20,
                                getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 3, // Shows 0, 3, 6, 9...
                                    getTitlesWidget: (value, meta) => Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(toBanglaNumber(value.toInt()), style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                    ),
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: 20,
                                    getTitlesWidget: (value, meta) => Text('${toBanglaNumber(value.toInt())}%', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                  ),
                                ),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: currentDay.points.map((pt) => FlSpot(pt.x, pt.y)).toList(),
                                  isCurved: true,
                                  color: Colors.cyanAccent,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.white,
                                      strokeWidth: 1,
                                      strokeColor: Colors.cyanAccent,
                                    ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.cyanAccent.withOpacity(0.3),
                                        Colors.cyanAccent.withOpacity(0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(color: Colors.white24, height: 40),

                        const Text(
                          'দৈনিক প্রতিবেদন',
                          style: TextStyle(color: Color(0xFF00D3B9), fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${currentDay.dayName}, বাতাসের আর্দ্রতা ${toBanglaNumber(currentDay.minVal)}% থেকে ${toBanglaNumber(currentDay.maxVal)}% এর মধ্যে থাকবে।',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
