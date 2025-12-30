import 'package:bmd_weather_app/controllers/prayer_controller.dart';
import 'package:bmd_weather_app/core/widgets/sun_and_moon_widget/sunrise_arc_widget.dart';
import 'package:bmd_weather_app/core/widgets/sun_and_moon_widget/sunset_arc_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for DateFormat

import '../../../controllers/theme_controller.dart';

class SunAndMoonWidget extends StatelessWidget {
  final PrayerTimeController controller = Get.put(PrayerTimeController());
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

  /// Helper to convert API time string (HH:mm or HH:mm:ss) to TimeOfDay
  TimeOfDay _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return TimeOfDay(hour: 6, minute: 0); // Default fallback
    }
    try {
      // Handles "18:30" or "18:30:00"
      DateTime date = DateFormat(timeString.split(":").length == 3 ? "HH:mm:ss" : "HH:mm").parse(timeString);
      return TimeOfDay(hour: date.hour, minute: date.minute);
    } catch (e) {
      return TimeOfDay(hour: 6, minute: 0);
    }
  }

  /// Helper to add minutes to a TimeOfDay
  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final newDt = dt.add(Duration(minutes: minutes));
    return TimeOfDay(hour: newDt.hour, minute: newDt.minute);
  }

  @override
  Widget build(BuildContext context) {
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
                const Icon(Icons.arrow_drop_down, color: Colors.white),
                Spacer(),
                Text(
                  "details".tr,
                  style: TextStyle(
                    color: themeController.themeMode.value == ThemeMode.light
                        ? Colors.black
                        : Color(0xFF00E5CA),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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

            // --- Phase Info (Static for now, can be dynamic later) ---
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
                      Text('waxing_gibbous'.tr, style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
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

            // --- Sunrise / Moonrise Arcs (Dynamic) ---
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: controller.obx(
                    (state) {
                  // 1. Get String data from controller state
                  // Assuming your PrayerModel has 'sunrise' and 'sunset' fields in 'result'
                  // Adjust field names (e.g., state?.result?.sunrise) based on your actual Model
                  final String? sunriseStr = state?.result?.sunrise;
                  final String? sunsetStr = state?.result?.sunset;

                  // 2. Parse to TimeOfDay
                  final TimeOfDay sunriseTime = _parseTime(sunriseStr);
                  final TimeOfDay sunsetTime = _parseTime(sunsetStr);

                  // 3. Calculate Moonrise (Sunset + 1 min) & Moonset (Sunrise - 1 min)
                  final TimeOfDay moonriseTime = _addMinutes(sunsetTime, 1);
                  final TimeOfDay moonsetTime = _addMinutes(sunriseTime, -1);

                  return Column(
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
                  );
                },
                // Fallback while loading or if error
                onLoading: Center(child: CircularProgressIndicator()),
                onError: (err) => Center(child: Text("Unable to load times")),
                onEmpty: Center(child: Text("No data available")),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}