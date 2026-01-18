import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/rainfall_controller.dart';

class RainyDayDetailsPage extends StatefulWidget {
  @override
  State<RainyDayDetailsPage> createState() => _RainyDayDetailsPageState();
}

class _RainyDayDetailsPageState extends State<RainyDayDetailsPage> {
  // Use the correct name for the controller
  final RainFallController controller = Get.put(RainFallController());

  final isBangla = Get.locale?.languageCode == 'bn';
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
        title: Text('rainfall_details_title'.tr), // Updated title
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.rainDays.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final currentDay =
              controller.rainDays[controller.selectedRainDay.value];

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
                      itemCount: controller.rainDays.length,
                      itemBuilder: (context, index) {
                        final item = controller.rainDays[index];
                        final isSelected =
                            controller.selectedRainDay.value == index;

                        return GestureDetector(
                          onTap: () => controller.selectedRainDay.value = index,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 70,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.dateDisplay,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  item.dayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Main Content Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBangla
                              ?"${toBanglaNumber(currentDay.minVal)} – ${toBanglaNumber(currentDay.maxVal)} মি.মি."
                              :'${currentDay.minVal} – ${currentDay.maxVal} mm',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          isBangla
                              ?'সম্ভাব্য বৃষ্টিপাতের পরিমাণ'
                              : 'Possible Rainfall Amount',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // BAR CHART
                        SizedBox(
                          height: 250,
                          child: BarChart(
                            BarChartData(
                              maxY: (currentDay.maxVal + 5).clamp(10, 100),
                              // Dynamic height
                              barGroups:
                                  currentDay.points.map((pt) {
                                    return BarChartGroupData(
                                      x: pt.x.toInt(),
                                      barRods: [
                                        BarChartRodData(
                                          toY: pt.y == 0 ? 0.5 : pt.y,
                                          width: 14, // Slightly wider for better visibility
                                         //for 0 values so they look like "placeholders"
                                          color: pt.y == 0 ? Colors.white : Colors.cyanAccent,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(4),
                                              ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      // Show labels for every 6 hours
                                      if (value % 3 == 0) {
                                        return Text(
                                          isBangla
                                              ?toBanglaNumber(value)
                                              : value.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget:
                                        (value, meta) => Text(
                                          isBangla
                                              ?toBanglaNumber(value)
                                              : value.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 5,
                              ),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),

                        const Divider(color: Colors.white24, height: 40),

                        Text(
                          isBangla
                              ?'দৈনিক প্রতিবেদন'
                              : 'Daily Report',
                          style: TextStyle(
                            color: Color(0xFF00D3B9),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isBangla
                              ?'${currentDay.dayName} বৃষ্টিপাতের গড় পরিমাণ ${toBanglaNumber(currentDay.avgVal)} মি.মি. হতে পারে। সর্বোচ্চ বৃষ্টিপাত ${toBanglaNumber(currentDay.maxVal)} মি.মি. পর্যন্ত পৌঁছাতে পারে।'
                              :'On ${currentDay.dayName}, the average rainfall is expected to be around ${currentDay.avgVal} mm, with a maximum reaching up to ${currentDay.maxVal} mm.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
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
