import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utills/app_color.dart';
import '../water_watch_controller/navigation/navigation_controller.dart';

class WaterWatchNavigationView extends GetView<WaterWatchNavigationController> {
  const WaterWatchNavigationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNavbarItem(Icons.dashboard_outlined, "home".tr, 0),
              buildNavbarItem(Icons.bar_chart, "record".tr, 1),
              buildNavbarItem(Icons.sms_outlined, "sms".tr, 2),
              buildNavbarItem(Icons.settings, "settings".tr, 3),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.currentScreen),
    );
  }


  Widget buildNavbarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => {controller.changePage(index)},
      splashFactory: NoSplash.splashFactory,
      child: Container(
        color: Colors.transparent,
        width: 85.w,
        height: 60.h,
        child: Column(
          children: [
            Obx(()=> Icon( icon,
                color: controller.currentTab.value == index
                    ? AppColors().app_primary
                    : Colors.black54) ),
            Obx(()=> Text( label,
              style: GoogleFonts.notoSansBengali( fontWeight: controller.currentTab.value == index
                  ? FontWeight.bold
                  : FontWeight.normal,
                color:  controller.currentTab.value == index
                    ? AppColors().app_primary
                    : Colors.black54),
            ))
          ],
        ),
      ),
    );
  }
}
