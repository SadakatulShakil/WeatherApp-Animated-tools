import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utills/app_color.dart';
import '../water_watch_controller/dashboard/DashboardController.dart';
import '../water_watch_controller/profile/ProfileController.dart';

class WaterWatchProfilePage extends StatefulWidget {
  @override
  State<WaterWatchProfilePage> createState() => _WaterWatchProfilePageState();
}

class _WaterWatchProfilePageState extends State<WaterWatchProfilePage> {
  final controller = Get.put(WaterWatchProfileController());
  final isBangla = Get.locale?.languageCode == 'bn';
  final WaterWatchDashboardController d_controller =
      Get.find<WaterWatchDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors().app_secondary,
        resizeToAvoidBottomInset: true,
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
                  "profile_title".tr,
                  style: GoogleFonts.notoSansBengali(
                    color: Color(0xFF0D6EA8),
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      title: "confirm_text".tr,
                      middleText: "log_out_alert".tr,
                      textConfirm: "yes".tr,
                      textCancel: "no".tr,
                      onConfirm: controller.logout,
                    );
                  },
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.red.shade100,
                    child: Icon(Icons.logout, color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Obx(
          () => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16.h),

                  // Profile Picture
                  Stack(
                    children: [
                      CircleAvatar(
                        maxRadius: 65.r,
                        backgroundColor: AppColors().app_primary,
                        child: CircleAvatar(
                          radius: 63.r,
                          backgroundImage: controller.selectedImagePath.value.isNotEmpty
                              ? FileImage(File(controller.selectedImagePath.value))
                              : controller.photo.value.startsWith('https://api3.ffwc.gov.bd')
                              ? NetworkImage(controller.photo.value)
                              : AssetImage("assets/images/profile.png") as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue.shade200,
                          foregroundColor: AppColors().app_secondary,
                          radius: 18.r,
                          child: IconButton(
                            onPressed: () {
                              controller.pickImage();
                            },
                            icon: Icon(Icons.camera_alt_rounded, size: 20.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Name
                        sectionLabel("first_name_label".tr),
                        profileTextField(controller.firstNameController),

                        SizedBox(height: 16.h),

                        sectionLabel("last_name_label".tr),
                        profileTextField(controller.lastNameController),

                        SizedBox(height: 16.h),

                        sectionLabel("mobile_view_only".tr),
                        disabledField(controller.mobileController),

                        SizedBox(height: 16.h),

                        sectionLabel("profile_info_address".tr),
                        profileTextField(controller.addressController),

                        SizedBox(height: 16.h),

                        // ------------ STATIONS -----------
                        sectionLabel("station_list_view_only".tr),
                        SizedBox(height: 6.h),

                        // if (d_controller.waterLevelStation.isNotEmpty)
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "water_level_list_item".tr,
                        //         style: smallLabelText(),
                        //       ),
                        //       Wrap(
                        //         spacing: 6.w,
                        //         runSpacing: 6.h,
                        //         children: d_controller.waterLevelStation.map((loc) {
                        //           return stationChip(isBangla ? loc.nameBn : loc.name);
                        //         }).toList(),
                        //       ),
                        //       SizedBox(height: 12.h),
                        //     ],
                        //   ),

                        if (d_controller.rainfallStation.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "rainfall_item".tr,
                                style: smallLabelText(),
                              ),
                              SizedBox(height: 8.h),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: d_controller.rainfallStation.map((loc) {
                                  return stationChip(isBangla ? loc.name : loc.name);
                                }).toList(),
                              ),
                              divider(),
                            ],
                          ),
                        SizedBox(height: 24.h),
                        // Update Button
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: controller.updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors().btn_bg,
                              foregroundColor: AppColors().app_secondary,
                              textStyle: GoogleFonts.notoSansBengali(fontSize: 16.sp, ),
                              minimumSize: Size(100, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "profile_info_update_button".tr,
                              style: GoogleFonts.notoSansBengali(color: Colors.white,),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------- Reusable Widgets -----------------

Widget sectionLabel(String text) {
  return Text(
    text,
    style: GoogleFonts.notoSansBengali(
      color: Colors.black87,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
    ),
  );
}

Widget profileTextField(TextEditingController c) {
  return TextField(
    controller: c,
    cursorColor: AppColors().app_primary,
    style: GoogleFonts.notoSansBengali(fontSize: 14.sp, color: Colors.black87),
  );
}

Widget disabledField(TextEditingController c) {
  return TextField(
    controller: c,
    enabled: false,
    style: GoogleFonts.notoSansBengali(color: Colors.black87),
  );
}

Widget divider() {
  return Divider(color: Colors.grey.shade300, thickness: 1);
}

Widget stationChip(String name) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: Colors.blue.shade200),
    ),
    child: Text(
      name,
      style: GoogleFonts.notoSansBengali(fontSize: 10.sp, color: Colors.black87),
    ),
  );
}

TextStyle smallLabelText() {
  return GoogleFonts.notoSansBengali(
    color: AppColors().app_primary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
}
