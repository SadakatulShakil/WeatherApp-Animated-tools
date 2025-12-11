import 'package:bmd_weather_app/water_watch_pages/station_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../water_watch_controller/dashboard/DashboardController.dart' show WaterWatchDashboardController;
import '../water_watch_models/assign_rainfall_model.dart';
import '../water_watch_models/assign_station_model.dart';

class WaterWatchDashboardPage extends StatelessWidget {
  final WaterWatchDashboardController controller = Get.put(WaterWatchDashboardController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with greeting and bell
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("welcome".tr, style: GoogleFonts.notoSansBengali(fontSize: 16.sp, color: Colors.black54, fontWeight: FontWeight.bold)),
                                SizedBox(width: 16.w),
                                Obx(() => Text(controller.initTime.value,
                                    style: GoogleFonts.notoSansBengali(fontSize: 16.sp, color: Colors.black54, fontWeight: FontWeight.bold))
                                )
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Obx(() => Text(controller.fullname.value,
                                style: GoogleFonts.notoSansBengali(fontSize: 22.sp, fontWeight: FontWeight.bold))
                            )
                          ],
                        ),
                      ),
                      ///Notification section
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(NotificationPage(),
                      //       transition: Transition.rightToLeft);
                      //   },
                      //   child: Stack(
                      //     alignment: Alignment.topRight,
                      //     children: [
                      //       CircleAvatar(
                      //         radius: 20,
                      //         backgroundColor: Colors.white,
                      //         child: Icon(Icons.notifications_none, color: Colors.black87),
                      //       ),
                      //       Positioned(
                      //         top: 4,
                      //         right: 4,
                      //         child: Container(
                      //           width: 10,
                      //           height: 10,
                      //           decoration: BoxDecoration(
                      //             color: Colors.red,
                      //             shape: BoxShape.circle,
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  // Center image
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        lottie.Lottie.asset(
                          'assets/json/water_anim.json',
                          width: 250.w,
                          height: 250.h,
                          repeat: true,
                        ),
                        Image.asset(
                          'assets/images/ruler.png', // Your central image
                          width: 120.w,
                          height: 120.h,
                        ),
                      ],
                    ),
                  ),
                  // Grid
                  // Dynamic List for water level
                  Text("water_level_list_item".tr, style: GoogleFonts.notoSansBengali(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 120.h,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: lottie.Lottie.asset('assets/json/loading_anim.json', width: 80, height: 80));
                      }

                      return controller.waterLevelStation.isNotEmpty
                          ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.waterLevelStation.length,
                        separatorBuilder: (context, index) => SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          return waterLevelStationCard(controller.waterLevelStation[index], 'water_level');
                        },
                      )
                          : Center(
                        child: Text(
                          "empty_data".tr,
                          style: GoogleFonts.notoSansBengali(fontSize: 16.sp, color: Colors.black54),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 32.h),
                  Text("rainfall_item".tr, style: GoogleFonts.notoSansBengali(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 120.h,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: lottie.Lottie.asset('assets/json/loading_anim.json', width: 80, height: 80),);
                      }

                      print('objective: ${controller.rainfallStation.length}');
                      return controller.rainfallStation.isNotEmpty
                          ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.rainfallStation.length,
                        separatorBuilder: (context, index) => SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          return rainfallStationCard(controller.rainfallStation[index], 'rainfall');
                        },
                      )
                          : Center(
                        child: Text(
                          "empty_data".tr,
                          style: GoogleFonts.notoSansBengali(fontSize: 16.sp, color: Colors.black54),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget waterLevelStationCard(WaterLevelStation location, String type) {
    return GestureDetector(
      onTap: () {
        print("Tapped on location: ${location.nameBn} & ${location.stationId}");
        Get.to(
          WaterWatchStationReportPage(),
          arguments: {'item': location, 'type': type},
          transition: Transition.leftToRight,
        );
      },
      child: Container(
        width: 180.w, // prevent shrinking
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.blue.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             "subtitle_station".tr,
              style: GoogleFonts.notoSansBengali(fontSize: 13.sp, color: Colors.black54),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    Get.locale?.languageCode == 'bn'
                        ? (location.nameBn.isNotEmpty ? location.nameBn : location.name)
                        : (location.name.isNotEmpty ? location.name : location.nameBn),
                    style: GoogleFonts.notoSansBengali(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.arrow_forward_ios, size: 16.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget rainfallStationCard(RainfallStation location, String type) {
    return GestureDetector(
      onTap: () {
        print("Tapped on location: ${location.nameBn} & ${location.stationId}");
        Get.to(
          WaterWatchStationReportPage(),
          arguments: {'item': location, 'type': type},
          transition: Transition.leftToRight,
        );
      },
      child: Container(
        width: 180.w, // prevent shrinking
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.blue.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "subtitle_station".tr,
              style: GoogleFonts.notoSansBengali(fontSize: 13.sp, color: Colors.black54),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    Get.locale?.languageCode == 'bn'
                        ? (location.nameBn.isNotEmpty ? location.nameBn : location.name)
                        : (location.name.isNotEmpty ? location.name : location.nameBn),
                    style: GoogleFonts.notoSansBengali(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.arrow_forward_ios, size: 16.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}