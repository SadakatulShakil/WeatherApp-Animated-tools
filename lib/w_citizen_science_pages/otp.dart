import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utills/app_color.dart';
import '../w_citizen_science_controller/otp/OtpController.dart';

class CitizenScienceOtp extends StatefulWidget {
  const CitizenScienceOtp({super.key});

  @override
  State<CitizenScienceOtp> createState() => _CitizenScienceOtpState();
}

class _CitizenScienceOtpState extends State<CitizenScienceOtp> {

  CitizenScienceOtpController controller = Get.put(CitizenScienceOtpController());

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
                "সিটিজেন সেয়েন্স",
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
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/citizen.svg', width: 100.w, height: 100.h),
              SizedBox(height: 16.h),
              Text("otp_title".tr, style: GoogleFonts.notoSansBengali( fontSize: 20.sp,fontWeight: FontWeight.w700, color: AppColors().black_font_color) ),
              Text('${"otp_message".tr}${controller.mobile}' , style: GoogleFonts.notoSansBengali(color: AppColors().black_font_color),),
              SizedBox(height: 16),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 64.h,
                      width: 64.w,
                      child: TextField(
                        controller: controller.otp1,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: TextStyle(color: AppColors().black_font_color, fontSize: 20),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.r),
                            borderSide: BorderSide(color: AppColors().btn_bg),
                          ),
                        ),
                        cursorColor: AppColors().btn_bg,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 64.h,
                      width: 64.w,
                      child: TextField(
                        controller: controller.otp2,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: TextStyle(color: AppColors().black_font_color, fontSize: 20),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: BorderSide(color: AppColors().btn_bg),
                      ),
                    ),
                    cursorColor: AppColors().btn_bg,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 64.h,
                      width: 64.w,
                      child: TextField(
                        controller: controller.otp3,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: TextStyle(color: AppColors().black_font_color, fontSize: 20),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.r),
                            borderSide: BorderSide(color: AppColors().btn_bg),
                          ),
                        ),
                        cursorColor: AppColors().btn_bg,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 64.h,
                      width: 64.w,
                      child: TextField(
                        controller: controller.otp4,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: TextStyle(color: AppColors().black_font_color, fontSize: 20),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.r),
                            borderSide: BorderSide(color: AppColors().btn_bg),
                          ),
                        ),
                        cursorColor: AppColors().btn_bg,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.w, top: 0, right: 30.w, bottom: 0),
                  child: ElevatedButton(
                    onPressed: controller.loginClick,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().btn_bg,
                      padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: Text("login_btn".tr, style: GoogleFonts.notoSansBengali(color: Colors.white, fontSize: 16.sp)),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                child: Obx(()=> Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${'wait'.tr} ${controller.second.value} ${'after_wait'.tr}.", style: TextStyle(color: AppColors().black_font_color),),
                    controller.second.value == 0 ?
                    InkWell(
                      onTap: () { controller.resendOTP(); },
                      child: Text("resend_otp".tr, style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.w700, color: Colors.blue)),
                    ) : Text("resend_otp".tr)
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
