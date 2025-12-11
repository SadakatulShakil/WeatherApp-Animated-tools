import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../water_watch_controller/station_report/station_record_controller.dart';

class GraphicalPage extends StatelessWidget {
  final controller = Get.find<StationRecordController>();

  GraphicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. FLATTEN THE DATA
      // Instead of grouping by date, we take all values and put them in one list
      final allRecords = controller.groupedRecordsByDate.values
          .expand((element) => element)
          .toList();

      if (allRecords.isEmpty) {
        return Center(
          child: Text(
            'no_results_found'.tr,
            style: GoogleFonts.notoSansBengali(
                fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        );
      }

      // 2. SORT BY DATE & TIME
      // Assuming your model has a 'date' or 'dateTime' field.
      // If it's a string, we parse it. If it's already DateTime, just compare.
      allRecords.sort((a, b) {
        // Adjust 'dateTime' to whatever your actual variable name is in the model
        DateTime dateA = DateTime.parse(a.observationDate.toString());
        DateTime dateB = DateTime.parse(b.observationDate.toString());
        return dateA.compareTo(dateB);
      });

      // 3. PREPARE BAR DATA
      final List<BarChartGroupData> barGroups = [];
      double maxY = 0;

      for (int i = 0; i < allRecords.length; i++) {
        final record = allRecords[i];
        final double value = double.tryParse(record.waterLevel.toString()) ?? 0.0;

        if (value > maxY) maxY = value;

        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value,
                color: const Color(0xFF2E6596), // Deep blue
                width: 18.w, // Slightly thinner to fit more bars
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                  bottom: Radius.zero,
                ),
                backDrawRodData: BackgroundBarChartRodData(show: false),
              ),
            ],
          ),
        );
      }

      // Dynamic Y-axis max
      maxY = (maxY * 1.2).ceilToDouble();
      if (maxY == 0) maxY = 10;

      // Calculate width for scrolling (e.g., 50 pixels per bar)
      // This prevents the bars from being squished if there are many records
      double chartWidth = allRecords.length * 60.w;
      if (chartWidth < MediaQuery.of(context).size.width) {
        chartWidth = MediaQuery.of(context).size.width - 32.w; // Fill screen if few items
      }

      return Padding(
        padding: EdgeInsets.all(16.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable Horizontal Scrolling
          child: SizedBox(
            height: 450.h,
            width: chartWidth, // Dynamic Width
            child: BarChart(
              BarChartData(
                maxY: maxY,
                minY: 0,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    top: BorderSide.none,
                    right: BorderSide.none,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  // --- X AXIS (TIME & DATE) ---
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      interval: 1, // Show label for every bar
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < allRecords.length) {
                          // Pass the specific record to the label builder
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: _buildBottomTitle(allRecords[index].observationDate.toString()),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  // --- Y AXIS (VALUES) ---
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: maxY / 5,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "${englishToBanglaNumber(value.toInt().toString())}\nmm",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.notoSansBengali(
                              color: Colors.grey.shade600,
                              fontSize: 10.sp,
                              height: 1.2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ),
      );
    });
  }

  // --- HELPER: Build Time & Date Label ---
  Widget _buildBottomTitle(String dateString) {
    try {
      final date = DateTime.parse(dateString);

      // Format 1: Time (e.g., "6:00 PM" or "৬:০০ পিএম")
      String time = DateFormat('h:mm a').format(date);

      // Format 2: Date (e.g., "11 Dec" or "১১ ডিসে")
      String dayMonth = DateFormat('d MMM').format(date);

      if (Get.locale?.languageCode == 'bn') {
        // Convert Time to Bangla
        time = englishToBanglaNumber(time);

        // Convert Date to Bangla
        String day = englishToBanglaNumber(DateFormat('d').format(date));
        String month = _banglaMonth(date.month);
        dayMonth = "$day $month";
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TIME (Top Line)
          Text(
            time,
            style: GoogleFonts.notoSansBengali(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
          // DATE (Bottom Line)
          Text(
            dayMonth,
            style: GoogleFonts.notoSansBengali(
              color: Colors.grey.shade600,
              fontSize: 10.sp,
            ),
          ),
        ],
      );
    } catch (e) {
      return const Text("");
    }
  }

  String englishToBanglaNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], bangla[i]);
    }
    return output;
  }

  String _banglaMonth(int monthIndex) {
    const months = [
      'জানু', 'ফেব', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্ট', 'অক্টো', 'নভেম', 'ডিসে'
    ];
    return months[monthIndex - 1];
  }
}