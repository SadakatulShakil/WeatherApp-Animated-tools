import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../controllers/theme_controller.dart';
import 'air_quality_animation.dart';

class AirQualityWidget extends StatelessWidget {
  final String currentValue;
  final String currentAnimValue;
  final String start;
  final String end;

  AirQualityWidget({
    super.key,
    required this.currentValue,
    required this.currentAnimValue,
    required this.start,
    required this.end,
  });

  final ThemeController themeController = Get.find<ThemeController>();

  // Accessing the locale logic
  bool get isBangla => Get.locale?.languageCode == 'bn';

  // --- LOGIC: Normalize for Calculation ---
  String _normalizeToEnglish(String input) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(bn[i], en[i]);
    }
    return input;
  }

  // --- DISPLAY: Convert for UI ---
  String _toBangla(String input) {
    if (!isBangla) return input;
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(en[i], bn[i]);
    }
    return input;
  }

  String formattedTime(String dateStr) {
    try {
      // Standardize input (replace space with T for ISO format)
      String cleanDate = _normalizeToEnglish(dateStr).replaceAll(' ', 'T');
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

  @override
  Widget build(BuildContext context) {
    // Determine color based on theme
    final Color textColor = themeController.themeMode.value == ThemeMode.light
        ? Colors.black
        : Colors.white;

    // Safely parse the value for the animation
    double numericValue = double.tryParse(_normalizeToEnglish(currentValue)) ?? 0.0;

    return GestureDetector(
      onTap: () {
        // Get.to(()=>AirQualityDetailsWidget());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: themeController.themeMode.value == ThemeMode.light
                ? [Colors.white, Colors.white]
                : [const Color(0xFF3986DD), const Color(0xFF3986DD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.wind_power, color: textColor, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'air_quality_title'.tr,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: textColor.withOpacity(0.1), height: 1),
              const SizedBox(height: 10),

              // LARGE VALUE DISPLAY
              Text(
                _toBangla(numericValue.toInt().toString()),
                style: TextStyle(
                  color: textColor.withOpacity(0.9),
                  fontSize: 65,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // DESCRIPTION TEXT
              Text(
                isBangla
                    ? '${formattedTime(start)} - ${formattedTime(end)} এর মধ্যে এয়ার কোয়ালিটির পরিমাণ ${_toBangla(currentValue)}'
                    : 'Air quality level between ${formattedTime(start)} to ${formattedTime(end)} is $currentValue',
                style: TextStyle(color: textColor, fontSize: 14),
              ),

              const SizedBox(height: 16),

              // ANIMATION BAR
              AirQualityAnimated(currentValue: numericValue),
            ],
          ),
        ),
      ),
    );
  }
}