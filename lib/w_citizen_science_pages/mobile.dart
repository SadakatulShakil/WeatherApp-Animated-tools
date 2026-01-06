import 'package:bmd_weather_app/w_citizen_science_controller/mobile/MobileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../utills/app_color.dart';

class CitizenScienceMobile extends StatefulWidget {
  const CitizenScienceMobile({super.key});

  @override
  State<CitizenScienceMobile> createState() => _CitizenScienceMobileState();
}

class _CitizenScienceMobileState extends State<CitizenScienceMobile> {

  CitizenScienceMobileController controller = Get.put(CitizenScienceMobileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().app_secondary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
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
                  color: Colors.black87,
                  size: 22,
                ),
              ),

              SizedBox(width: 8.w),

              // Custom title
              Text(
                "সিটিজেন সায়েন্স",
                style: GoogleFonts.notoSansBengali(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.isChecking.value
          ? Center(
              child: Lottie.asset('assets/json/loading_anim.json', width: 80, height: 80),
            )
          : Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svg/citizen.svg', width: 150.w, height: 150.h),
                    SizedBox(height: 16),
                    Text(
                      '"${"login_greetings".tr} "',
                      style: GoogleFonts.notoSansBengali(
                          fontSize: 20.sp,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          color: AppColors().black_font_color
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("authorize_text".tr, style: GoogleFonts.notoSansBengali(
                      fontSize: 14.sp,
                      color: AppColors().black_font_color,
                    ),),
                    SizedBox(height: 32),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30.w, top: 0, right: 30.w, bottom: 0),
                      child: TextField(
                        controller: controller.mobile,
                        style: TextStyle(color: AppColors().black_font_color),
                        decoration: InputDecoration(
                          hintText: "e.g. 01xxxxxxxxx",
                          hintStyle: GoogleFonts.notoSansBengali(color: AppColors().black_font_color,),
                          label: Text(
                            "mobile_no_hint".tr,
                            style: GoogleFonts.notoSansBengali(color: AppColors().black_font_color,),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide:
                                BorderSide(color: AppColors().black_font_color),
                          ),
                        ),
                        cursorColor: AppColors().black_font_color,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 30.w, top: 0, right: 30.w, bottom: 0),
                        child: ElevatedButton(
                          onPressed: controller.gotoOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().btn_bg,
                            padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text("otp_btn".tr,
                              style: GoogleFonts.notoSansBengali(
                                  color: Colors.white, fontSize: 16.sp,)),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text("Powered by RIMES", style: GoogleFonts.notoSansBengali(
                      fontSize: 12.sp,
                      color: AppColors().black_font_color,
                    ),),
                  ],
                ),
              ),
            )),
    );
  }
}
