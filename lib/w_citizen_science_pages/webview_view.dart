import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../utills/app_color.dart';
import '../w_citizen_science_controller/webview/webview_controller.dart';

class WebviewView extends GetView<WebviewController> {
  const WebviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default close
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        controller.handleBackNavigation();
      },
      child: Scaffold(
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
                  onPressed: () => controller.handleBackNavigation(),
                  padding: EdgeInsets.only(left: 8.w),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.cyan,
                    size: 22,
                  ),
                ),
                SizedBox(width: 8.w),
                // Custom title
                Obx(() => Text(
                  controller.title.value,
                  style: GoogleFonts.notoSansBengali(
                    color: Color(0xFF0D6EA8),
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                )),
              ],
            ),
          ),
        ),
        body: Obx(() {
          if (!controller.hasInternet.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.grey, size: 60.w),
                    SizedBox(height: 16.h),
                    Text(
                      "No internet connection",
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: 120.w,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () => controller.onInit(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().app_primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text("Retry", style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              WebViewWidget(controller: controller.webViewController),
              Obx(() => Visibility(
                visible: controller.isPageLoading.value != 100,
                child: CircularProgressIndicator(
                  backgroundColor: AppColors().app_secondary,
                  color: AppColors().app_primary,
                ),
              )),
            ],
          );
        }),
      ),
    );
  }
}