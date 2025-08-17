import 'package:bmd_weather_app/core/widgets/sun_and_moon_widget/sunrise_arc_widget.dart';
import 'package:bmd_weather_app/core/widgets/sun_and_moon_widget/sunset_arc_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/theme_controller.dart';

class SunAndMoonWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: themeController.themeMode.value == ThemeMode.light
          ? [Colors.white, Colors.white]
              :[Color(0xFF3986DD), Color(0xFF3986DD)],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                    SizedBox(width: 16,),
                    Text(
                      'সূর্য ও চাঁদ',
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
                Spacer(),
                Text(
                  "বিস্তারিত",
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
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.grey.shade300
                  : Colors.grey.shade500,
              height: 1,
            ),
          ),
          SizedBox(height: 8),
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
                  child: Image.asset('assets/sun_moon.png', width: 70, height: 75,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ওয়াক্সিং গিব্বাস', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                        ? Colors.black
                        : Colors.white, fontSize: 24),),
                    Text('চন্দ্রের অবস্থান', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                        ? Colors.black
                        : Colors.white, fontSize: 16),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 8),
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
                        child: Image.asset('assets/full_moon.png', width: 45, height: 45,),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('০৪/১৩', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white, fontSize: 22),),
                        Text('পূর্ণিমা', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white, fontSize: 14),),
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
                        child: Image.asset('assets/last_quarter.png', width: 40, height: 40,),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('০৪/২১', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white, fontSize: 22),),
                        Text('কৃষ্ণপক্ষ', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white, fontSize: 14),),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SunriseArcWidget(
                        sunrise: TimeOfDay(hour: 5, minute: 30),
                        sunset: TimeOfDay(hour: 18, minute: 45),
                        currentTime: TimeOfDay.now(),
                      ),
                    ),
                    const SizedBox(width: 16), // Space between two widgets
                    Expanded(
                      child: SunsetArcWidget(
                        moonrise: TimeOfDay(hour: 18, minute: 46),
                        moonset: TimeOfDay(hour: 5, minute: 29),
                        currentTime: TimeOfDay.now(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Sun and Moon icons
        ],
      ),
    );
  }
}