import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/forecast_details_controller.dart';


class FifteenDaysForecastPage extends StatefulWidget {
  @override
  State<FifteenDaysForecastPage> createState() => _FifteenDaysForecastPageState();
}

class _FifteenDaysForecastPageState extends State<FifteenDaysForecastPage> {
  final ForecastDetailsController controller = Get.put(ForecastDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: const Text('পরবর্তী ১৫ দিন'),
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
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.fifteenDays.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final item = controller.fifteenDays[index];
                          final isSelected = index == controller.selectedDay.value;

                          return GestureDetector(
                            onTap: () => controller.selectedDay.value = index,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFFFF993F)
                                      : Color(0xFF056AA4),
                                  border: Border.all(
                                    color: isSelected
                                        ? Color(0xFFFFAD66)
                                        : Color(0xFF3293CC),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SizedBox(
                                  width: 75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(item['day'] as String, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  child: ListView.builder(
                    itemCount: controller.forecastData.length,
                    itemBuilder: (context, index) {
                      final item = controller.forecastData[index];
                      return Card(
                        elevation: 0,
                        color: Color(0xFF2A8EC8).withOpacity(.4),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Color(0xFF268CC8), width: 1.5)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF2A8EC8).withOpacity(.4),
                                border: Border.all(color: Color(0xFF268CC8), width: 1.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 12, right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item['time'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        Text(item['temperature'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(item['date'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  _iconLabel('বৃষ্টিপাতের সম্ভাবনা', item['rainChance'], icon: Icons.water_drop_outlined),
                                  _iconLabel('বৃষ্টিপাত পরিমাণ', item['rainAmount'], icon: Icons.water_outlined),
                                  _iconLabel('আর্দ্রতা', item['humidity'], icon: Icons.water_drop_outlined),
                                  _iconLabel('দূরদর্শিতা', item['visibility'], icon: Icons.visibility_outlined),
                                  _iconLabel('অতিবেগুনী রশ্মি', item['uvIndex'], icon: Icons.wb_sunny_outlined),
                                  _iconLabel('বাতাসের গতি', item['windSpeed'], icon: Icons.air_outlined),
                                  _iconLabel('বাতাসের দিক', item['windDirection'], icon: Icons.navigation_outlined),
                                  _iconLabel('মেঘ', item['cloud']),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconLabel(String label, String value, {IconData icon = Icons.info_outline}) {
    return SizedBox(
      width: 90,
      height: 65,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon( icon, color: Colors.white),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
