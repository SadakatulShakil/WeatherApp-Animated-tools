import 'package:bmd_weather_app/controllers/wind_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/forecast_details_controller.dart';


class WindDetailsPage extends StatefulWidget {
  @override
  State<WindDetailsPage> createState() => _WindDetailsPageState();
}

class _WindDetailsPageState extends State<WindDetailsPage> {

  final WindController controller = Get.put(WindController());
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
    final List<double> brown = List<double>.from(dayData["brown"]);
    final minVal = brown.reduce((a, b) => a < b ? a : b);
    final maxVal = brown.reduce((a, b) => a > b ? a : b);

    return "${toBanglaNumber(minVal)}–${toBanglaNumber(maxVal)} মিটার/সেকেন্ড";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: const Text('বাতাস'),
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
                    if (controller.windDays.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.windDays.length,
                      itemBuilder: (context, index) {
                        final item = controller.windDays[index];
                        final isSelected = index == controller.selectedWindDay.value;

                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 16.0 : 8.0,
                            right: index == controller.windDays.length - 1 ? 16.0 : 8.0,
                          ),
                          child: GestureDetector(
                            onTap: () => controller.selectedWindDay.value = index,
                            child: Obx(() {
                              final isSelected = controller.selectedWindDay.value == index;
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
                                          item.date,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          item.day,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Icon(
                                          item.icon,
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
                  child: Obx(() {
                    if (controller.windDays.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    // Now it’s safe to access index 0 or selectedWindDay
                    final dayData = controller.windDays[controller.selectedWindDay.value].toJson();
                    final chartData = controller.windDays[controller.selectedWindDay.value];
                    final brownValues = chartData.brown; final greenValues = chartData.green;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getChartTitle(dayData),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                minX: 0,
                                maxX: 24,
                                backgroundColor: Colors.transparent,
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 32,
                                      interval: 6,
                                      getTitlesWidget: (value, meta) {
                                        final hour = value.toInt();
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            hour.toString().padLeft(2, '0'), // 00, 06, etc.
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      interval: 5,
                                      getTitlesWidget: (value, meta) {
                                        const allowedValues = [0, 5, 10, 15, 20, 25, 30];
                                        if (allowedValues.contains(value.toInt())) {
                                          return Text(
                                            '${value.toInt().toString().padLeft(2, '0')} মি/সে',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(color: Colors.white24),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: brownValues
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                                        .toList(),
                                    isCurved: true,
                                    color: Colors.brown.shade400,
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.brown.shade400.withOpacity(0.8),
                                          Colors.brown.shade600.withOpacity(0.4),
                                        ],
                                      ),
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: greenValues
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                                        .toList(),
                                    isCurved: true,
                                    color: Colors.green.shade400,
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.green.shade400.withOpacity(0.8),
                                          Colors.green.shade600.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )

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
                  })
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
