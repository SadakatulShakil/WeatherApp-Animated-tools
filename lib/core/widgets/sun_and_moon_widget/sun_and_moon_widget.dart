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

  // --- Helper: Normalize to English for DateTime/Double parsing ---
  String _toEnglish(String input) {
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(bn[i], en[i]);
    }
    return input;
  }

  String _normalizeToEnglish(String input) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(bn[i], en[i]);
    }
    return input;
  }

  // --- Helper: Convert English to Bangla for Display ---
  String _toBangla(String input) {
    if (!isBangla) return input;
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(en[i], bn[i]);
    }
    return input;
  }

  String formattedTime(String dateStr) {
    try {
      // Standardize input (replace space with T for ISO format)
      String cleanDate = _toEnglish(dateStr).replaceAll(' ', 'T');
      DateTime dateTime = DateTime.parse(cleanDate);

      // Use intl's DateFormat for reliable 12h formatting
      String time = DateFormat('hh:mm').format(dateTime);
      String period = dateTime.hour >= 12
          ? (isBangla ? 'PM' : 'PM')
          : (isBangla ? 'AM' : 'AM');

      return "${_toBangla(time)} $period";
    } catch (e) {
      return _toBangla(dateStr);
    }
  }

  TimeOfDay stringToTimeOfDay(String timeStr) {
    if (timeStr.isEmpty) return const TimeOfDay(hour: 0, minute: 0);

    // 1. Normalize digits (Bangla to English) and uppercase for AM/PM
    String cleanTime = _normalizeToEnglish(timeStr).toUpperCase().trim();

    try {
      // 2. Handle AM/PM format (e.g., "06:22 AM" or "6:22 PM")
      if (cleanTime.contains("AM") || cleanTime.contains("PM")) {
        int hour = int.parse(cleanTime.split(":")[0]);
        int minute = int.parse(cleanTime.split(":")[1].split(" ")[0]);
        bool isPM = cleanTime.contains("PM");

        if (isPM && hour < 12) hour += 12;
        if (!isPM && hour == 12) hour = 0;

        return TimeOfDay(hour: hour, minute: minute);
      }

      // 3. Handle 24-hour format (e.g., "17:06")
      else if (cleanTime.contains(":")) {
        List<String> parts = cleanTime.split(":");
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (e) {
      debugPrint("Error parsing TimeOfDay: $e");
    }

    return const TimeOfDay(hour: 0, minute: 0); // Fallback
  }

  @override
  Widget build(BuildContext context) {
    // Use Obx to listen to changes in homeController
    return Obx(() {
      final current = hController.forecast.value?.result?.current;

      print("SunAndMoonWidget: Current Data($isBangla) - ${current?.sunrise}, ${current?.sunset}, ${current?.moonrise}, ${current?.moonset}");
      // Parse times directly from the 'current' object
      final sunriseStr = formattedTime(current?.sunrise.toString() ?? '');
      final sunsetStr = formattedTime(current?.sunset ?? '');
      final moonriseStr = formattedTime(current?.moonrise ?? '');
      final moonsetStr = formattedTime(current?.moonset ?? '');

      // Convert String to TimeOfDay
      final TimeOfDay sunriseTime = stringToTimeOfDay(sunriseStr);
      final TimeOfDay sunsetTime = stringToTimeOfDay(sunsetStr);
      final TimeOfDay moonriseTime = stringToTimeOfDay(moonriseStr);
      final TimeOfDay moonsetTime = stringToTimeOfDay(moonsetStr);

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
                            languageCode: isBangla ? 'bn' : 'en',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SunsetArcWidget(
                            moonrise: moonriseTime,
                            moonset: moonsetTime,
                            currentTime: TimeOfDay.now(),
                            languageCode: isBangla ? 'bn' : 'en',
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