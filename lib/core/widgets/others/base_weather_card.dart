import 'package:bmd_weather_app/core/widgets/others/survey_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/home_controller.dart';
import '../../../utills/app_color.dart';

class BaseWeatherCard extends StatelessWidget {
  final String? iconPath;
  final String? iconUrl;
  final String location;
  final String? date;
  final String temp;
  final String tempMax;
  final String tempMin;
  final String rain;
  final String rain_unit;
  final String feels_like;
  final String type;
  final String temp_unit;
  final String humidity;
  final String wind;
  final bool loading;
  final HomeController controller;
  final VoidCallback? onLocationTap;

  BaseWeatherCard({
    Key? key,
    this.iconPath,
    this.iconUrl,
    this.location = "-/-",
    this.date,
    required this.temp,
    required this.tempMax,
    required this.tempMin,
    required this.rain,
    required this.rain_unit,
    required this.feels_like,
    required this.type,
    required this.temp_unit,
    required this.humidity,
    required this.wind,
    this.loading = true,
    required this.controller,
    this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      // Adjusted padding to match the visual spacing in the design
      padding: EdgeInsets.fromLTRB(16.w, topPadding + 28.h, 16.w, 10.h),
      width: double.infinity,
      // Removed fixed height to allow content to size naturally, or keep roughly 250
       height: 250.h+topPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- 1. Top Section: Location & Date ---
          GestureDetector(
            onTap: onLocationTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      location,
                      style: GoogleFonts.notoSansBengali(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: Colors.white, // Changed to white for visibility on sky bg
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.keyboard_arrow_down_sharp,
                        color: Colors.white, size: 24.r),
                  ],
                ),
                if (date != null)
                  Text(
                    date!,
                    style: GoogleFonts.notoSansBengali(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 20.h), // Spacing between header and main temp

          // --- 2. Middle Section: Condition, Temp (Left) & Button (Right) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left Side: Condition Tag + Temperature
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF20558B).withOpacity(0.8), // Dark Blue color from design
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      type,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Temperature Text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        temp,
                        style: GoogleFonts.anekBangla(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          temp_unit,
                          style: GoogleFonts.anekBangla(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Right Side: "My Observation" Button
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: GestureDetector(
                  onTap: () {
                    showTopSurveyDialog(context: context, controller: controller);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00CEB5), // Teal color
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "আমার পর্যবেক্ষণ",
                          style: GoogleFonts.notoSansBengali(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Spacer(),

          // --- 3. Bottom Section: Details Row ---
          SizedBox(
            width: double.infinity,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 3.h, // vertical space if wrapped
              children: [
                Text(
                  feels_like,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 14.sp,
                    color: AppColors().app_primary_bg,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 6.w, right: 0.w),
                  child: Container(height: 16.h, width: 1.w, color: Colors.cyan),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/svg/high_temp.svg', height: 20.h, width: 20.w),
                    SizedBox(width: 3.w),
                    Text(
                      tempMax,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 14.sp,
                        color: AppColors().app_primary_bg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/svg/low_temp.svg', height: 20.h, width: 20.w),
                    SizedBox(width: 3.w),
                    Text(
                      tempMin,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 14.sp,
                        color: AppColors().app_primary_bg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.w, right: 6.w),
                  child: Container(height: 16.h, width: 1.w, color: Colors.cyan),
                ),

                Text(
                  '$rain $rain_unit',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 14.sp,
                    color: AppColors().app_primary_bg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}