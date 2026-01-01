import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/theme_controller.dart';
import '../../screens/humidity_details_page.dart';

class HumidityCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String subtitle;
  final IconData icon;

  HumidityCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.subtitle,
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

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return GestureDetector(
      onTap: () {
        /// Navigate to details page if needed
        //Get.to(() => HumidityDetailsPage(), transition: Transition.rightToLeft);
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
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                subtitle,
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
