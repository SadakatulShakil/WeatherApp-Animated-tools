import 'package:bmd_weather_app/controllers/settings_controller.dart';
import 'package:bmd_weather_app/core/widgets/under_development/under_development_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../core/screens/dashboard_preference.dart';
import '../core/screens/icon_preference.dart';
import 'app_color.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ThemeController themeController = Get.find<ThemeController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    bool isLight = themeController.themeMode.value == ThemeMode.light;

    return Drawer(
      backgroundColor: isLight ? Colors.white : Colors.grey.shade900,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          _BuildHeader(),

          SizedBox(height: 12.h),

          _buildSectionTitle("Preferences"),

          _drawerItem(
            icon: Icons.room_preferences,
            title: "Dashboard Preference",
            isLight: isLight,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(
                () => DashboardPreference(),
                transition: Transition.rightToLeft,
              );
            },
          ),

          _drawerItem(
            icon: Icons.file_present_outlined,
            title: "Icon Preference",
            isLight: isLight,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(
                () => IconPreferencePage(),
                transition: Transition.rightToLeft,
              );
            },
          ),

          _drawerItem(
            icon: Icons.satellite_alt,
            title: "Satellite Image",
            isLight: isLight,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(
                    () => UnderDevelopmentScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),

          _drawerItem(
            icon: Icons.crisis_alert_sharp,
            title: "Radder Image",
            isLight: isLight,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(
                    () => UnderDevelopmentScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),

          _drawerItem(
            icon: Icons.notification_important,
            title: "Notification",
            isLight: isLight,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(
                    () => UnderDevelopmentScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),

          _drawerItem(
            icon: Icons.warning_amber,
            title: "Weather Alerts",
            isLight: isLight,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(
                    () => UnderDevelopmentScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),

          _drawerItem(
            icon: Icons.connect_without_contact,
            title: "Emergency Contacts",
            isLight: isLight,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(
                    () => UnderDevelopmentScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),

          _drawerItem(
            icon: Icons.dark_mode,
            isLight: isLight,
            title: "Theme Preference",
            trailing: _buildThemeSwitch(),
            onTap: () {
              themeController.toggleTheme(
                themeController.themeMode.value != ThemeMode.dark,
              );
            },
          ),

          _drawerItem(
            icon: Icons.language,
            isLight: isLight,
            title: "profile_language_select".tr,
            trailing: _buildLanguageSegment(controller: settingsController),
            onTap: () {},
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  //------------------ HEADER ------------------//
  Widget _BuildHeader() {
    return  Container(
      height: 180.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/day.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.5),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Mirpur DOHS, Dhaka",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
              ),
              SizedBox(height: 4.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Fri 5.00 PM",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //------------------ SECTION TITLE ------------------//

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  //------------------ DRAWER ITEM ------------------//

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required bool isLight,
    required Function() onTap,
    Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
        leading: Icon(
          icon,
          size: 24.sp,
          color: isLight ? Color(0xFF165ABC) : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: isLight ? Color(0xFF165ABC) : Colors.white,
          ),
        ),
        trailing: trailing,
        onTap: title == 'profile_select_language'.tr ? null : onTap,
        dense: title == 'profile_select_language'.tr ? false: true,
      ),
    );
  }

  //------------------ THEME SWITCH ------------------//

  Widget _buildThemeSwitch() {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        themeController.toggleTheme(!isDark);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52.w,
        height: 26.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          color: isDark ? Colors.black87 : Colors.grey.shade300,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(3.w),
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.yellow.shade700 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.r,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //------------------ LANGUAGE TOGGLE ------------------//

  Widget _buildLanguageSegment({required SettingsController controller}) {
    bool isBN = controller.selectedLanguage.indexOf(true) == 1;

    return GestureDetector(
      onTap: () {
        controller.changeLanguage(isBN ? 0 : 1); // toggle
      },
      child: Container(
        width: 80.w,
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          color: Colors.grey.shade300,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Sliding knob
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isBN ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.all(3.w),
                width: 40.w,
                height: 25.h,
                decoration: BoxDecoration(
                  color: AppColors().app_primary_bg,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // EN/BN labels with smooth color animation
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isBN ? Colors.black54 : Colors.redAccent,
                      ),
                      child: const Text("EN"),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isBN ? Colors.red : Colors.black54,
                      ),
                      child: const Text("BN"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
