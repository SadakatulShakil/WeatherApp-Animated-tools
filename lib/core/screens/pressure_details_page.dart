import 'package:bmd_weather_app/controllers/pressure_controller.dart';
import 'package:bmd_weather_app/controllers/wind_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/forecast_details_controller.dart';


class PressureDetailsPage extends StatefulWidget {
  @override
  State<PressureDetailsPage> createState() => _PressureDetailsPageState();
}

class _PressureDetailsPageState extends State<PressureDetailsPage> {

  final PressureController controller = Get.put(PressureController());
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
        title: const Text('চাপ'),
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
                    if (controller.pressureDay.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.pressureDay.length,
                      itemBuilder: (context, index) {
                        final item = controller.pressureDay[index];

                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 16.0 : 8.0,
                            right: index == controller.pressureDay.length - 1 ? 16.0 : 8.0,
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
                      if (controller.pressureDay.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      // Now it’s safe to access index 0 or selectedWindDay
                      final dayData = controller.pressureDay[controller.selectedWindDay.value].toJson();
                      final chartData = controller.pressureDay[controller.selectedWindDay.value];
                      final brownValues = chartData.brown;

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
                            child: BarChart(
                              BarChartData(
                                minY: 900,
                                maxY: 1150,
                                groupsSpace: 10,
                                alignment: BarChartAlignment.spaceAround,
                                gridData: FlGridData(show: true,
                                  horizontalInterval: 50,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.white24,
                                      strokeWidth: 0.5,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 50,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final labels = ["0-6", "6-12", "12-18", "18-24"];
                                        if (value.toInt() >= 0 && value.toInt() <= 3) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              labels[value.toInt()],
                                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                      interval: 1,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(color: Colors.white24),
                                ),
                                barGroups: List.generate(4, (i) {
                                  // Calculate average of brown values per 6-hour interval
                                  final start = i * 6;
                                  final end = start + 6;
                                  final intervalValues = brownValues.sublist(start, end);
                                  final avg = intervalValues.reduce((a, b) => a + b) / intervalValues.length;

                                  return BarChartGroupData(
                                    x: i, // 0,1,2,3 → corresponds to 0–6,6–12,12–18,18–24
                                    barRods: [
                                      BarChartRodData(
                                        toY: avg,
                                        color: Colors.yellow,
                                        width: 10,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  );
                                }),
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
                            'বুধবার, ১৪ মে, ২০২৫ তারিখে বিকেল ৫:০০ টা পর্যন্ত, ঢাকার বায়ুমণ্ডলীয় চাপ প্রায় ১০০১ মিলিবার.',
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
                            'বায়ুমণ্ডলীয় চাপ পৃথিবীর পৃষ্ঠে বাতাসের দ্বারা প্রযুক্ত বল পরিমাপ করে। উচ্চ চাপের ফলে আকাশ পরিষ্কার হয়ে গেলে আবহাওয়া ব্যবস্থা তৈরি হয়, অন্যদিকে নিম্নচাপের ফলে মেঘ, বৃষ্টি বা ঝড় হতে পারে।',
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
