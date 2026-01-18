import 'package:bmd_weather_app/core/screens/ultraviolate_details_page.dart';
import 'package:bmd_weather_app/core/widgets/other_info_widget/uv_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/theme_controller.dart';

class UvIndexCard extends StatelessWidget {
  final String title;
  final String value;
  final String start;
  final String end;
  final String unit;
  final IconData icon;

  UvIndexCard({
    super.key,
    required this.title,
    required this.value,
    required this.start,
    required this.end,
    required this.unit,
    required this.icon,
  });

  String banglaToEnglishNumber(String input) {
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];

    for (int i = 0; i < bangla.length; i++) {
      input = input.replaceAll(bangla[i], english[i]);
    }
    return input;
  }
  final isBangla = Get.locale?.languageCode == 'bn';
  String englishNumberToBangla(String input) {
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], bangla[i]);
    }
    return input;
  }

  String formatedDate(String dateStr) {
    DateTime dateTime = DateTime.parse(isBangla? banglaToEnglishNumber(dateStr) : dateStr);
    return isBangla
        ? "${dateTime.hour}:${englishNumberToBangla(dateTime.minute.toString().padLeft(2, '0'))} ${dateTime.hour >= 12 ? 'pm' : 'am'}"
        : "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'pm' : 'am'}";
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return GestureDetector(
      onTap: () {
        Get.to(() => UltraviolateDetailsPage(), transition: Transition.rightToLeft);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeController.themeMode.value == ThemeMode.light
              ? Colors.white
              : Color(0xFF3986DD),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  size: 22,
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Value Section
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isBangla ? englishNumberToBangla(banglaToEnglishNumber(value).split('.')[0]) : value.split('.')[0],
                          style: TextStyle(
                            color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.black.withValues(alpha: 0.7)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 70,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        unit,
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black.withValues(alpha: 0.7)
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UvIndicatorWidget(currentValue: 4),
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                isBangla
                  ? '${englishNumberToBangla(formatedDate(start))} - ${englishNumberToBangla(formatedDate(end))} এর মধ্যে অতিবেগুনী রশ্মির পরিমাণ $value $unit'
                      :'Ultraviolet index between ${formatedDate(start)} to ${formatedDate(end)} is $value $unit',
                style: TextStyle(
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}