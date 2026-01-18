import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/wind_controller.dart';

class WindDetailsPage extends StatefulWidget {
  @override
  State<WindDetailsPage> createState() => _WindDetailsPageState();
}

class _WindDetailsPageState extends State<WindDetailsPage> {
  final WindController controller = Get.put(WindController());

  final isBangla = Get.locale?.languageCode == 'bn';
  // Helper for Bangla Numbers
  String toBanglaNumber(num value) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯', '.'];
    return value
        .toStringAsFixed(1)
        .split('')
        .map((ch) => bn[en.indexOf(ch)] ?? ch)
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: Text('wind_details_title'.tr, style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // --- Top Day Selector ---
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.windDays.length,
                    itemBuilder: (context, index) {
                      final item = controller.windDays[index];
                      final isSelected = controller.selectedWindDay.value == index;

                      return GestureDetector(
                        onTap: () => controller.selectedWindDay.value = index,
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

                const SizedBox(height: 20),

                // --- Main Chart Card ---
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() {
                      if (controller.windDays.isEmpty) {
                        return const SizedBox(height: 200);
                      }

                      final dayData = controller.windDays[controller.selectedWindDay.value];
                      final points = dayData.points;

                      // Calculate dynamic Y-axis Max for better visuals
                      double maxY = dayData.maxVal + 5;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dynamic Title
                          Text(
                            isBangla
                                ?"${toBanglaNumber(dayData.minVal)} – ${toBanglaNumber(dayData.maxVal)} কিমি/ঘণ্টা"
                                :"${dayData.minVal.toStringAsFixed(1)} – ${dayData.maxVal.toStringAsFixed(1)} km/h",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isBangla
                                ?'বাতাসের গতিবেগ (3 ঘণ্টা ব্যবধানে)'
                                :'Wind Speed (3-hour intervals)',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // --- The Chart ---
                          SizedBox(
                            height: 250,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: maxY, // Dynamic max height
                                minX: 0,
                                maxX: 24,   // 24 Hours
                                backgroundColor: Colors.transparent,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 5,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.white10,
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  // Bottom Titles (Hours: 00, 03, 06...)
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 32,
                                      interval: 3, // Show label every 3 units (hours)
                                      getTitlesWidget: (value, meta) {
                                        final hour = value.toInt();
                                        // Only show titles if valid hours
                                        if (hour % 3 == 0 && hour <= 24) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              isBangla
                                                  ?toBanglaNumber(hour).padLeft(2, '0')
                                                  :hour.toString().padLeft(2, '0'),
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 10,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  // Left Titles (Speed values)
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 35,
                                      interval: 5, // Interval for Y axis labels
                                      getTitlesWidget: (value, meta) {
                                        if (value == 0) return const SizedBox.shrink();
                                        return Text(
                                          isBangla
                                              ?toBanglaNumber(value.toInt())
                                              :value.toInt().toString(),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 10,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),

                                // --- Single Line Data ---
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: points.map((p) => FlSpot(p.x, p.y)).toList(),
                                    isCurved: true, // Smooth line
                                    curveSmoothness: .5,
                                    color: const Color(0xFF00D3B9), // Teal Color
                                    barWidth: 0,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 0,
                                          color: Colors.white,
                                          strokeWidth: 0,
                                          strokeColor: const Color(0xFF00D3B9),
                                        );
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFF00E5CA),
                                          const Color(0xFF00D3B9).withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                // Tooltip setup
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    tooltipRoundedRadius: 8,
                                    tooltipPadding: const EdgeInsets.all(8),
                                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                      return touchedBarSpots.map((barSpot) {
                                        return LineTooltipItem(
                                          "${toBanglaNumber(barSpot.y)} কিমি/ঘণ্টা",
                                          const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // --- Dynamic Description ---
                          Text(
                            isBangla
                                ?'দৈনিক প্রতিবেদন'
                                :'Daily Report',
                            style: TextStyle(
                                color: Color(0xFF00D3B9),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isBangla
                                ?'${dayData.dayName}, বাতাসের গতিবেগ ${toBanglaNumber(dayData.minVal)} কিমি/ঘণ্টা থেকে ${toBanglaNumber(dayData.maxVal)} কিমি/ঘণ্টা পর্যন্ত থাকবে।'
                                :'On ${dayData.dayName}, wind speed will range from ${dayData.minVal.toStringAsFixed(1)} km/h to ${dayData.maxVal.toStringAsFixed(1)} km/h.',
                            style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // --- Static Info ---
                          Text(
                            isBangla
                                ?'বাতাসের গতি সম্পর্কে'
                                :'About Wind Speed',
                            style: TextStyle(
                                color: Color(0xFF00D3B9),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isBangla
                                ?'বাতাসের গতি অনেক সময় গড় ব্যবহার করে গণনা করা হয়। এই গড়ের চেয়ে কম বাতাসের গতিটা একটি ঝোড়ো হাওয়া সাধারণত ২০ সেকেন্ডের কম স্থায়ী হয়।'
                                :'Wind speed is often calculated using averages over time. A wind speed lower than this average is typically sustained for less than 20 seconds.',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                height: 1.5
                            ),
                          ),
                        ],
                      );
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}