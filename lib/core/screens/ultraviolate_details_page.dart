import 'dart:math';

import 'package:bmd_weather_app/controllers/rain_controller.dart';
import 'package:bmd_weather_app/controllers/ultraviolate_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UltraviolateDetailsPage extends StatefulWidget {
  @override
  State<UltraviolateDetailsPage> createState() => _UltraviolateDetailsPageState();
}

class _UltraviolateDetailsPageState extends State<UltraviolateDetailsPage> {
  final UltraviolateRayController controller = Get.put(UltraviolateRayController());

  Color getSmoothHeatColor(double value) {
    final t = value.clamp(0, 30) / 30;
    if (t < 0.5) {
      return Color.lerp(Colors.green, Colors.orange, t * 2)!;
    } else {
      return Color.lerp(Colors.orange, Colors.red, (t - 0.5) * 2)!;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: const Text('অতিবেগুনী রশ্মি'),
        elevation: 0,
        leading:  GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.rayDays.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        final item = controller.rayDays[index];
                        final isSelected = index == controller.selectedRayDay.value;

                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 16.0 : 8.0,
                            right: index == controller.rayDays.length - 1 ? 16.0 : 8.0,
                          ),
                          child: GestureDetector(
                            onTap: () => controller.selectedRayDay.value = index,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 0),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: isSelected ? Color(0xFF2686BE) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(item['date'] as String, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    Text(item['day'] as String, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    const SizedBox(height: 8),
                                    Icon(item['icon'] as IconData, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '৭.৩-১১.৬ মিটার/সেকেন্ড',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '২.১ মাইল/ঘণ্টা থেকে বাতাসের উত্তর ঝাঁপটা',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final speeds = controller.rayDays[controller.selectedRayDay.value]['values'] as List<double>;
                        return SizedBox(
                          height: 250,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: 30,
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 5,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.white24,
                                  strokeWidth: 1,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      final hours = ['০০', '০৬', '১২', '১৮', '২৪'];
                                      if (value.toInt() < hours.length) {
                                        return Text(
                                          hours[value.toInt()],
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    getTitlesWidget: (value, _) => Text(
                                      '${value.toInt()} মি/সে',
                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  spots: List.generate(speeds.length, (i) => FlSpot(i.toDouble(), speeds[i])),
                                  barWidth: 0,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red,
                                        Colors.orange,
                                        Colors.green,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Divider(
                        color: Colors.white24,
                        height: 32,
                      ),
                      const Text(
                        'দৈনিক প্রতিবেদন',
                        style: TextStyle(color: Color(0xFF00D3B9), fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'সোমবার, বাতাসের গতিবেগ ৭.২ মাইল প্রতি ঘন্টা থেকে ১১.১ মাইল প্রতি ঘন্টা পর্যন্ত থাকবে, এবং ২২.১ মাইল প্রতি ঘন্টা পর্যন্ত দমকা হাওয়া বইবে।',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Divider(
                        color: Colors.white24,
                        height: 32,
                      ),
                      const Text(
                        'বাতাসের গতি এবং ঝোড়ো হাওয়া সম্পর্কে',
                        style: TextStyle(color: Color(0xFF00D3B9), fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'বাতাসের গতি এবং ঝোড়ো হাওয়া সম্পর্কে: বাতাসের গতি অনেক সময় গড় ব্যবহার করে গণনা করা হয়। এই গড়ের চেয়ে কম বাতাসের গতিটা একটি ঝোড়ো হাওয়া সাধারণত ২০ সেকেন্ডের কম স্থায়ী হয়।',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
