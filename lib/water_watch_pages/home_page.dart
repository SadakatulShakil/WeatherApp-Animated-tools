import 'package:bmd_weather_app/water_watch_pages/profile_page.dart';
import 'package:bmd_weather_app/water_watch_pages/station_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utills/app_color.dart';
import '../water_watch_controller/dashboard/DashboardController.dart';

class CitizenSciencePage extends StatefulWidget {
  const CitizenSciencePage({super.key});

  @override
  State<CitizenSciencePage> createState() => _CitizenSciencePageState();
}

class _CitizenSciencePageState extends State<CitizenSciencePage> {

  final WaterWatchDashboardController controller = Get.put(WaterWatchDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().app_secondary,

      // ------------ CUSTOM APP BAR ------------
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: AppColors().app_secondary,
          elevation: 0,
          automaticallyImplyLeading: false, // remove default back
          titleSpacing: 0,

          title: Row(
            children: [
              // iOS back button
              IconButton(
                onPressed: () => Get.back(),
                padding: EdgeInsets.only(left: 8.w),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.cyan,
                  size: 22,
                ),
              ),

              SizedBox(width: 8.w),

              // Custom title
              Text(
                "সিটিজেন সেয়েন্স",
                style: GoogleFonts.notoSansBengali(
                  color: Color(0xFF0D6EA8),
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),

          actions: [
            GestureDetector(
              onTap: () {
                // Profile action
                Get.to(() => WaterWatchProfilePage());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.black12,
                  backgroundImage: AssetImage("assets/icons/profile.png"),
                ),
              ),
            )
          ],
        ),
      ),

      // ------------ BODY ------------
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [

            GestureDetector(
              onTap: () {
                // Navigate to Rain Gauge Data Collection Page
                Get.to(() => StationPage(), transition: Transition.rightToLeft);
              },
              child: _cardItem(
                iconPath: "assets/svg/rainguage_icon.svg",
                title: "রেইনগেজ ডাটা কালেকশন",
                sub: "মোট সংগ্রহীত তথ্য: ৫৪",
              ),
            ),

            SizedBox(height: 16.h),

            _cardItem(
              iconPath: "assets/svg/landslide_icon.svg",
              title: "ল্যান্ডস্লাইড ডাটা কালেকশন",
              sub: "মোট সংগ্রহীত তথ্য: ৩৭",
            ),

          ],
        ),
      ),
    );
  }

  // ------------ CARD WIDGET ------------
  Widget _cardItem({required String iconPath, required String title, required String sub}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFE1F4FF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(0xFFD6F0FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 55.w,
            height: 55.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Center(
              child: SvgPicture.asset(iconPath, fit: BoxFit.cover,),
            ),
          ),

          SizedBox(width: 14.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                sub,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 14.sp,
                  color: Colors.black87.withOpacity(0.9),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
