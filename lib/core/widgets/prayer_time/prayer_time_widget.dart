import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/theme_controller.dart';

class PrayerTimeWidget extends StatelessWidget {
  PrayerTimeWidget({super.key});
  final ThemeController themeController = Get.find<ThemeController>();
  final Color greenAccent = const Color(0xFF23FF90);

  // Widget for Sehri/Iftar Cards
  Widget _buildTimeCard(
      String icon, String time, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              icon,
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label, // সেহরির সময় or ইফতারের সময়
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget for the bottom prayer time list
  Widget _buildDailyPrayerTime(String name, String time) {
    return Column(
      children: <Widget>[
        Text(
          name, // ফজর, যোহর, আসর, মাগরিব, এশা
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Container(
          width: 40,
          height: 3,
          color: greenAccent,
        ),
        const SizedBox(height: 5),
        Text(
          time, // 05.34 am, 01.30 pm, etc.
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
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
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Header: Prayer Time ---
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/prayer_time_icon.svg',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'নামাজের সময়',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.grey.shade300
                    : Colors.grey.shade500,
                height: 1,
              ),
              const SizedBox(height: 10),

              // --- Sehri & Iftar Times ---
              Row(
                children: <Widget>[
                  _buildTimeCard(
                    'assets/svg/seheri_icon.svg',
                    '4.35 AM',
                    'সেহরির সময়',
                  ),
                  _buildTimeCard(
                    'assets/svg/seheri_icon.svg',
                    '06.41 PM',
                    'ইফতারের সময়',
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- Daily Prayer Times ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildDailyPrayerTime('ফজর', '05.34 am'),
                  _buildDailyPrayerTime('যোহর', '01.30 pm'),
                  _buildDailyPrayerTime('আসর', '04.40 pm'),
                  _buildDailyPrayerTime('মাগরিব', '6.17 pm'),
                  _buildDailyPrayerTime('এশা', '8.30 pm'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}