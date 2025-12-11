import 'package:bmd_weather_app/water_watch_pages/station_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../utills/app_color.dart';
import '../water_watch_controller/dashboard/DashboardController.dart'
    show WaterWatchDashboardController;
import '../water_watch_models/assign_rainfall_model.dart';
import '../water_watch_models/assign_station_model.dart';

class StationPage extends StatelessWidget {
  final WaterWatchDashboardController controller =
  Get.put(WaterWatchDashboardController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: Scaffold(
        backgroundColor: AppColors().app_secondary, // Clean white background
        // ------------------- APP BAR -------------------
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: AppBar(
            backgroundColor: AppColors().app_secondary,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.only(left: 16.w),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.cyan, // Match the cyan back arrow
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "সিটিজেন সায়েন্স", // Corrected Spelling
                  style: GoogleFonts.notoSansBengali(
                    color: Color(0xFF0D6EA8), // Blue Title Color
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        // ------------------- BODY -------------------
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sub Header
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  "নির্ধারিত স্টেশন",
                  style: GoogleFonts.notoSansBengali(
                    color: Color(0xFF0D6EA8), // Blue Header Color
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),

              // Grid Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: lottie.Lottie.asset(
                        'assets/json/loading_anim.json',
                        width: 80,
                        height: 80,
                      ),
                    );
                  }
                  if (controller.rainfallStation.isEmpty) {
                    return Center(
                      child: Text(
                        "empty_data".tr,
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 16.sp,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }
                  // ---------------- VERTICAL GRID VIEW ----------------
                  return GridView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    // Changed to Vertical scrolling
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(bottom: 20.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 1.4, // Adjusted aspect ratio to match card shape
                    ),
                    itemCount: controller.rainfallStation.length,
                    itemBuilder: (context, index) {
                      return rainfallStationCard(
                        controller.rainfallStation[index],
                        'rainfall',
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- REDESIGNED CARD WIDGET -------------------
  Widget rainfallStationCard(RainfallStation location, String type) {
    return GestureDetector(
      onTap: () {
        Get.to(
          WaterWatchStationReportPage(),
          arguments: {'item': location, 'type': type},
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFEBF8FE), // Light Blue Background
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Station ID (The big number)
                Text(
                  // Assuming stationId contains the number like "13"
                  // If it's English "13", you might need a helper to convert to Bengali if required
                  "00",
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D6EA8), // Dark Blue
                  ),
                ),
                // Arrow Icon
                Icon(
                  Icons.arrow_circle_right_outlined, // Rounded arrow icon
                  color: Color(0xFF0D6EA8),
                  size: 24.sp,
                ),
              ],
            ),

            // Station Name
            Text(
              Get.locale?.languageCode == 'bn'
                  ? (location.nameBn.isNotEmpty
                  ? location.name
                  : location.name)
                  : location.name,
              style: GoogleFonts.notoSansBengali(
                fontSize: 15.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}