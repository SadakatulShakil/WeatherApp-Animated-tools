import 'dart:math';

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

  String toBanglaNumber(num value) {
    const en = ['0','1','2','3','4','5','6','7','8','9','.'];
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯','.'];
    return value
        .toStringAsFixed(1) // one decimal place
        .split('')
        .map((ch) => bn[en.indexOf(ch)] ?? ch)
        .join();
  }

  String getChartTitle(Map<String, dynamic> dayData) {
    final List<double> values = List<double>.from(dayData["values"]);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return "${toBanglaNumber(minVal)}–${toBanglaNumber(maxVal)} মিটার/সেকেন্ড";
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
                  child: Obx(() {
                    if (controller.rayDays.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    final dayData = controller.rayDays[controller.selectedRayDay.value];

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.rayDays.length,
                      itemBuilder: (context, index) {
                        final item = controller.rayDays[index];

                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 16.0 : 8.0,
                            right: index == controller.rayDays.length - 1 ? 16.0 : 8.0,
                          ),
                          child: GestureDetector(
                            onTap: () => controller.selectedRayDay.value = index,
                            child: Obx(() {
                              final isSelected = controller.selectedRayDay.value == index;
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.all(6),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF2686BE) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ]
                                      : [],
                                  border: Border.all(
                                    color: Colors.white24,
                                    width: 1,
                                  ),
                                ),
                                child: AnimatedScale(
                                  scale: isSelected ? 1.1 : 1.0,
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  child: SizedBox(
                                    width: 55,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['date'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          item['day'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Icon(
                                          item['icon'],
                                          color: Colors.white,
                                          size: isSelected ? 24 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  }),
                ),
                SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Obx((){
                    final speeds = controller.rayDays[controller.selectedRayDay.value]['values'] as List<double>;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getChartTitle(controller.rayDays[controller.selectedRayDay.value]),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                        SizedBox(
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
                        ),
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
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
