import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/prayer_controller.dart';
import '../../../controllers/theme_controller.dart';

class PrayerTimeWidget extends StatelessWidget {
  PrayerTimeWidget({super.key});

  final ThemeController themeController = Get.find<ThemeController>();
  final PrayerTimeController controller = Get.put(PrayerTimeController());
  final isBangla =  Get.locale?.languageCode == 'bn';
  final Color greenAccent = const Color(0xFF23FF90);

  String englishToBanglaNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bangla  = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], bangla[i]);
    }
    return output;
  }

  Widget _buildTimeCard(String icon, String? time, String label, bool isDark) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              icon,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time ?? "--:--",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDailyPrayerTime(String name, String? time, bool isDark) {
    return Column(
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 40,
          height: 3,
          color: greenAccent,
        ),
        const SizedBox(height: 5),
        Text(
          time ?? "--:--",
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 12.sp
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDark = themeController.themeMode.value == ThemeMode.dark;

      return Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF3986DD), const Color(0xFF3986DD)]
                : [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // The controller.obx handles switching between Loading, Error, and Success widgets
          child: controller.obx(
                (prayerModel) {
              final data = prayerModel!.result!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // --- Header ---
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/prayer_time_icon.svg',
                            width: 24,
                            height: 24,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'prayer_times_title'.tr,
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade300,
                    height: 1,
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: <Widget>[
                      _buildTimeCard(
                          'assets/svg/seheri_icon.svg',
                          isBangla
                              ? 'ভোর ${englishToBanglaNumber(controller.formatTime(data.sehri)?.replaceAll(RegExp(r'\s?[APap][Mm]'), '') ?? "ভোর ")}'
                              : controller.formatTime(data.sehri),
                          'seheri_time'.tr,
                          isDark
                      ),
                      Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                      _buildTimeCard(
                          'assets/svg/ifter_icon.svg',
                          isBangla
                          ? 'সন্ধ্যা ${englishToBanglaNumber(controller.formatTime(data.iftar)?.replaceAll(RegExp(r'\s?[APap][Mm]'), '') ?? "সন্ধ্যা ")}'
                              : controller.formatTime(data.iftar),
                          'ifter_time'.tr,
                          isDark
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildDailyPrayerTime('fajr_time'.tr, isBangla
                        ? 'ভোর ${englishToBanglaNumber(controller.formatTime(data.fajr)?.replaceAll(RegExp(r'\s?[APap][Mm]'), '') ?? '--:--')}'
                        : controller.formatTime(data.fajr), isDark),
                      _buildDailyPrayerTime('juhr_time'.tr, isBangla
                          ? 'দুপুর ${englishToBanglaNumber(controller.formatTime(data.juhr)?.replaceAll(RegExp(r'\s?[APap][Mm]'), '') ?? '--:--')}'
                          : controller.formatTime(data.juhr), isDark),
                      _buildDailyPrayerTime('asr_time'.tr, isBangla
                          ? 'বিকাল ${englishToBanglaNumber(controller.formatTime(data.asr)?.replaceAll(RegExp(r'\s?[APap][Mm]'), '') ?? '--:--')}'
                          : controller.formatTime(data.asr), isDark),
                      _buildDailyPrayerTime('magrib_time'.tr, isBangla
                          ? 'সন্ধ্যা ${englishToBanglaNumber(controller.formatTime(data.magrib)?.replaceAll(RegExp(r'\s?[APap][Mm]'), '') ?? '--:--')}'
                          : controller.formatTime(data.magrib), isDark),
                      _buildDailyPrayerTime('isha_time'.tr, isBangla
                          ? 'রাত ${englishToBanglaNumber(controller.formatTime(data.isha)?.replaceAll(RegExp(r'\s?[APap][Mm]'), '') ?? '--:--')}'
                          : controller.formatTime(data.isha), isDark),
                    ],
                  ),
                ],
              );
            },

            onLoading: Center(
              child: Column(
                children: [
                  Lottie.asset(
                      'assets/json/loading_anim.json',
                      width: 80,
                      height: 80
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "data_load_indicator".tr,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            onError: (error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: isDark ? Colors.white70 : Colors.redAccent, size: 30),
                  const SizedBox(height: 10),
                  Text(
                    "Unable to load prayer times",
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () => controller.fetchPrayerTimes(),
                    child: const Text("Retry"),
                  )
                ],
              ),
            ),

            onEmpty: Center(
              child: Text(
                "empty_data".tr,
                style: TextStyle(color: isDark ? Colors.blue : Colors.black),
              ),
            ),
          ),
        ),
      );
    });
  }
}