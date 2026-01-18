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

  final isBangla = Get.locale?.languageCode == 'bn';
  Color getSmoothHeatColor(double value) {
    final t = value.clamp(0, 30) / 30;
    if (t < 0.5) {
      return Color.lerp(Colors.green, Colors.orange, t * 2)!;
    } else {
      return Color.lerp(Colors.orange, Colors.red, (t - 0.5) * 2)!;
    }
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

  String toBanglaNumber(String value) {
    const en = ['0','1','2','3','4','5','6','7','8','9','.'];
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯','.'];
    return value.split('').map((e) {
      final index = en.indexOf(e);
      return index != -1 ? bn[index] : e;
    }).join();
  }

  String getChartTitle(Map<String, dynamic> dayData) {
    final List<double> values = List<double>.from(dayData["values"]);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return isBangla
        ?"${toBanglaNumber(3.0.toString())}–${toBanglaNumber(4.0.toString())}"
        :"${minVal.toStringAsFixed(1)}–${maxVal.toStringAsFixed(1)}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: Text('uv_index_details_title'.tr),
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
                                          isBangla
                                              ? toBanglaNumber(item['date'].toString())
                                              : item['date'].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                        isBangla
                                        ? toBanglaNumber(item['day'].toString())
                                         : item['day'].toString(),
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
                        Text(
                          isBangla
                              ?'অতিবেগুনী রশ্মির পরিমাণ ৩ - ৪ হতে পারে'
                              :'Ultraviolet ray index may be 3 - 4',
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
                                horizontalInterval: 3,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.white24,
                                  strokeWidth: 1,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 3,
                                    getTitlesWidget: (value, _) {
                                      final hour = value.toInt();

                                      if ([0, 3, 6, 12, 15, 18, 21].contains(hour)) {
                                        return Text(
                                          isBangla ? toBanglaNumber(hour.toString()) : hour.toString(),
                                          style: const TextStyle(color: Colors.white, fontSize: 10),
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
                                      isBangla
                                          ?toBanglaNumber(value.toInt().toString())
                                          :'${value.toInt()}',
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
                        Text(
                          isBangla
                              ?'দৈনিক প্রতিবেদন'
                              :'Daily Report',
                          style: TextStyle(color: Color(0xFF00D3B9), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isBangla
                              ?'আজকে, অতিবেগুনী রশ্মির পরিমাণ ৩ - ৪ হতে পারে।'
                              :'Today, the ultraviolet ray index may be 3 - 4.',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Divider(
                          color: Colors.white24,
                          height: 32,
                        ),
                        Text(
                          isBangla
                              ?'অতিবেগুনী রশ্মি সম্পর্কে'
                              :'About Ultraviolet Rays',
                          style: TextStyle(color: Color(0xFF00D3B9), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isBangla
                              ?'বিশ্ব স্বাস্থ্য সংস্থার UV সূচক (UVI) অতিবেগুনী বিকিরণ পরিমাপ করে। UVI যত বেশি হবে, ক্ষতির সম্ভাবনা তত বেশি হবে এবং ক্ষতি তত দ্রুত ঘটতে পারে। UVI আপনাকে কখন সূর্য থেকে নিজেকে রক্ষা করতে হবে এবং কখন বাইরে থাকা এড়িয়ে চলতে হবে তা নির্ধারণ করতে সাহায্য করতে পারে। WHO 3 (মাঝারি) বা তার বেশি স্তরে ছায়া, সানস্ক্রিন টুপি এবং প্রতিরক্ষামূলক পোশাক ব্যবহারের পরামর্শ দেয়।'
                              :'The World Health Organization\'s UV Index (UVI) measures ultraviolet radiation. The higher the UVI, the greater the potential for harm and the faster the damage can occur. The UVI can help you determine when to protect yourself from the sun and when to avoid being outside. WHO recommends using shade, sunscreen, hats, and protective clothing at levels of 3 (moderate) or higher.',
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
