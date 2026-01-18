import 'package:bmd_weather_app/core/widgets/sun_and_moon_widget/sunrise_arc_widget.dart';
import 'package:bmd_weather_app/core/widgets/sun_and_moon_widget/sunset_arc_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/home_controller.dart';
import '../../../controllers/theme_controller.dart';

class SunAndMoonWidget extends StatelessWidget {
  // Removed PrayerTimeController
  final HomeController hController = Get.find<HomeController>();
  final ThemeController themeController = Get.find<ThemeController>();

  final bool isBangla = Get.locale?.languageCode == 'bn';

  String englishNumberToBangla(String input) {
    const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], bangla[i]);
    }
    return input;
  }

  /// Helper to convert API date-time string (yyyy-MM-dd HH:mm) to TimeOfDay
  TimeOfDay _parseTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return TimeOfDay(hour: 6, minute: 0); // Default fallback
    }
    try {
      String normalizedString = _normalizeToEnglish(dateTimeString);
      DateTime date = DateFormat("yyyy-MM-dd HH:mm").parse(normalizedString);

      return TimeOfDay(hour: date.hour, minute: date.minute);
    } catch (e) {
      // debugPrint("Time parse error: $e");
      return TimeOfDay(hour: 6, minute: 0);
    }
  }

  /// Helper to ensure digits are English before parsing
  String _normalizeToEnglish(String input) {
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];
    for (int i = 0; i < bangla.length; i++) {
      input = input.replaceAll(bangla[i], english[i]);
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    // Use Obx to listen to changes in homeController
    return Obx(() {
      final current = hController.forecast.value?.result?.current;

      // Parse times directly from the 'current' object
      final TimeOfDay sunriseTime = _parseTime(current?.sunrise);
      final TimeOfDay sunsetTime = _parseTime(current?.sunset);
      final TimeOfDay moonriseTime = _parseTime(current?.moonrise);
      final TimeOfDay moonsetTime = _parseTime(current?.moonset);

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: themeController.themeMode.value == ThemeMode.light
                ? [Colors.white, Colors.white]
                : [Color(0xFF3986DD), Color(0xFF3986DD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sunny_snowing,
                        color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'sun_moon_title'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  //const Icon(Icons.arrow_drop_down, color: Colors.white),
                  Spacer(),
                ],
              ),
              SizedBox(height: 8),
              Divider(
                color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.grey.shade300
                    : Colors.grey.shade500,
                height: 1,
              ),
              SizedBox(height: 8),

              // --- Phase Info ---
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: themeController.themeMode.value == ThemeMode.light
                              ? [Colors.blue.withValues(alpha: 0.5), Colors.blue.withOpacity(.5)]
                              : [Colors.white.withValues(alpha: 0.5), Colors.white.withOpacity(.5)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Image.asset('assets/sun_moon.png', width: 70, height: 75),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(current?.moonPhase ?? '', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white, fontSize: 24)),
                        Text('moon_position'.tr, style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white, fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),

              // --- Moon Dates Info ---
              Row(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: themeController.themeMode.value == ThemeMode.light
                                    ? [Colors.blue.withValues(alpha: 0.5), Colors.blue.withOpacity(.5)]
                                    : [Colors.white.withValues(alpha: 0.5), Colors.white.withOpacity(.5)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('assets/full_moon.png', width: 45, height: 45),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isBangla ? '০৪/১৩' : '04/13', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.black
                                : Colors.white, fontSize: 22)),
                            Text(isBangla ? 'পূর্ণিমা' : 'Full Moon', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.black
                                : Colors.white, fontSize: 14)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: themeController.themeMode.value == ThemeMode.light
                                    ? [Colors.blue.withValues(alpha: 0.5), Colors.blue.withOpacity(.5)]
                                    : [Colors.white.withValues(alpha: 0.5), Colors.white.withOpacity(.5)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset('assets/last_quarter.png', width: 40, height: 40),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isBangla ? '০৪/২১' : '04/21', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.black
                                : Colors.white, fontSize: 22)),
                            Text(isBangla ? 'কৃষ্ণপক্ষ' : 'Waxing', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.black
                                : Colors.white, fontSize: 14)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 8),

              // --- Sunrise / Moonrise Arcs (Using Data from HomeController) ---
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SunriseArcWidget(
                            sunrise: sunriseTime,
                            sunset: sunsetTime,
                            currentTime: TimeOfDay.now(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SunsetArcWidget(
                            moonrise: moonriseTime,
                            moonset: moonsetTime,
                            currentTime: TimeOfDay.now(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }
}