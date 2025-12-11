import 'package:bmd_weather_app/water_watch_pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/settings_controller.dart';


class WaterWatchSettingsPage extends StatelessWidget {

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                'settings'.tr,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.r),
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_outline, color: Colors.teal),
                      title: Text('my_profile'.tr,
                          style: GoogleFonts.notoSansBengali(fontSize: 16.sp,)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.h),
                      onTap: () {
                        Get.to(() => WaterWatchProfilePage());
                      },
                    ),
                    Divider(),

                    // 🔹 Uncomment when language selection is required
                    // ListTile(
                    //   leading: Icon(Icons.language, color: Colors.teal),
                    //   title: Text(
                    //     'profile_language_select'.tr,
                    //     style: TextStyle(fontSize: 16),
                    //   ),
                    //   trailing: Obx(
                    //     () => ToggleButtons(
                    //       borderRadius: BorderRadius.circular(10),
                    //       fillColor: AppColors().app_primary_bg,
                    //       selectedColor: AppColors().app_primary,
                    //       color: Colors.black54,
                    //       textStyle: TextStyle(fontSize: 12),
                    //       isSelected: controller.selectedLanguage,
                    //       onPressed: (int index) {
                    //         controller.changeLanguage(index);
                    //       },
                    //       children: [Text('EN'), Text('BN')],
                    //     ),
                    //   ),
                    // ),
                    // Divider(),

                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.redAccent),
                      title: Text(
                        'log_out'.tr,
                        style:
                        GoogleFonts.notoSansBengali(fontSize: 16.sp, color: Colors.redAccent),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          title: 'confirm_text'.tr,
                          middleText: 'log_out_alert'.tr,
                          textConfirm: 'yes'.tr,
                          textCancel: 'no'.tr,
                          onConfirm: () {
                            Get.back();
                            controller.logout();
                            // Get.offAll(WaterWatchMobile(), transition: Transition.rightToLeft);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
