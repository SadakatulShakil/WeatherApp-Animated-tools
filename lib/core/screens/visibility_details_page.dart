import 'package:bmd_weather_app/controllers/visibility_controller.dart';
import 'package:bmd_weather_app/controllers/wind_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/forecast_details_controller.dart';


class VisibilityDetailsPage extends StatefulWidget {
  @override
  State<VisibilityDetailsPage> createState() => _VisibilityDetailsPageState();
}

class _VisibilityDetailsPageState extends State<VisibilityDetailsPage> {

  final VisibilityController controller = Get.put(VisibilityController());
  final isBangla = Get.locale?.languageCode == 'bn';
  String toBanglaNumber(String value) {
    const en = ['0','1','2','3','4','5','6','7','8','9','.'];
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯','.'];
    return value.split('').map((e) {
      final index = en.indexOf(e);
      if (index != -1) {
        return bn[index];
      }
      return e;
    }).join();
  }

  String getBanglaDay(String day) {
    switch (day.toLowerCase()) {
      case 'saturday':
        return 'শনিবার';
      case 'sunday':
        return 'রবিবার';
      case 'monday':
        return 'সোমবার';
      case 'tuesday':
        return 'মঙ্গলবার';
      case 'wednesday':
        return 'বুধবার';
      case 'thursday':
        return 'বৃহস্পতিবার';
      case 'friday':
        return 'শুক্রবার';
      default:
        return day; // fallback
    }
  }

  String getChartTitle(Map<String, dynamic> dayData) {
    final List<double> brown = List<double>.from(dayData["brown"]);
    final minVal = brown.reduce((a, b) => a < b ? a : b);
    final maxVal = brown.reduce((a, b) => a > b ? a : b);

    return isBangla
        ?"${toBanglaNumber(minVal.toString())}–${toBanglaNumber(maxVal.toString())} কিমি।"
        :"${minVal.toStringAsFixed(1)}–${maxVal.toStringAsFixed(1)} km.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: Text('visibility_details_title'.tr),
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
                    if (controller.visibilityDays.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.visibilityDays.length,
                      itemBuilder: (context, index) {
                        final item = controller.visibilityDays[index];

                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 16.0 : 8.0,
                            right: index == controller.visibilityDays.length - 1 ? 16.0 : 8.0,
                          ),
                          child: GestureDetector(
                            onTap: () => controller.selectedVisibilityDay.value = index,
                            child: Obx(() {
                              final isSelected = controller.selectedVisibilityDay.value == index;
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
                                        Text(isBangla ? toBanglaNumber(item.date.toString()) : item.date,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        Text(isBangla
                                            ? getBanglaDay(item.day)
                                            : item.day,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
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
                    if (controller.visibilityDays.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    // Now it’s safe to access index 0 or selectedWindDay
                    final dayData = controller.visibilityDays[controller.selectedVisibilityDay.value].toJson();
                    final chartData = controller.visibilityDays[controller.selectedVisibilityDay.value];
                    final brownValues = chartData.brown;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isBangla ? getBanglaDay(getChartTitle(dayData)) : getChartTitle(dayData),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isBangla
                              ?'ভালো এবং স্পষ্ট দৃষ্টিসীমা'
                              :'Good and clear visibility',
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
                                          child: Text(isBangla
                                              ? toBanglaNumber(hour.toString().padLeft(2, '0'))
                                              : hour.toString().padLeft(2, '0'), // 00, 06, etc.
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
                                          return Text(isBangla
                                              ? '${toBanglaNumber(value.toInt().toString().padLeft(2, '0'))} কি.মি'
                                              : '${value.toInt().toString().padLeft(2, '0')} km',
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
                                    color: Colors.transparent,
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFFDCC10).withOpacity(0.7),
                                          Color(0xFFFFCD0F).withOpacity(0.05),
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
                        Text(
                          isBangla
                              ?'দৈনিক প্রতিবেদন'
                              :'Daily Report',
                          style: TextStyle(color: Color(0xFF00D3B9), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isBangla
                              ?'আজ, দৃষ্টিসীমা ভালো এবং পরিষ্কার দৃষ্টি ক্ষেত্র, ৯.৮ - ১৬.৪ কিমি'
                              :'Today, good visibility and clear sight range, 9.8 - 16.4 km',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Divider(
                          color: Colors.white24,
                          height: 32,
                        ),
                        Text(
                          'দৃষ্টিসীমা সম্পর্কে',
                          style: TextStyle(color: Color(0xFF00D3B9), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isBangla
                              ?'দৃষ্টিসীমা হল একটি পরিমাপ যা নির্ধারণ করে যে একটি পর্যবেক্ষক কত দূরত্ব পর্যন্ত স্পষ্টভাবে দেখতে পারে। এটি আবহাওয়ার পরিস্থিতি, যেমন কুয়াশা, বৃষ্টি, তুষারপাত এবং ধোঁয়ার দ্বারা প্রভাবিত হতে পারে। ভালো দৃষ্টিসীমা সাধারণত নিরাপদ যাতায়াত এবং কার্যক্রমের জন্য গুরুত্বপূর্ণ, বিশেষ করে বিমান চলাচল এবং সামুদ্রিক নেভিগেশনের ক্ষেত্রে।'
                              :'Visibility is a measure that determines how far a observer can see clearly. It can be affected by weather conditions such as fog, rain, snow, and smoke. Good visibility is generally important for safe travel and activities, especially in aviation and maritime navigation.',
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
