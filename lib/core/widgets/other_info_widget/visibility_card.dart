import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/theme_controller.dart';
import '../../screens/visibility_details_page.dart';

class VisibilityCard extends StatelessWidget {
  final String title;
  final String value;
  final String start;
  final String end;
  final String unit;
  final IconData icon;

  VisibilityCard({
    super.key,
    required this.title,
    required this.value,
    required this.start,
    required this.end,
    required this.unit,
    required this.icon,
  });

  bool get isBangla => Get.locale?.languageCode == 'bn';

  // --- Helper: Normalize digits to English for safe parsing ---
  String _toEnglish(String input) {
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(bn[i], en[i]);
    }
    return input;
  }

  // --- Helper: Convert English to Bangla for the UI ---
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
      // 1. Normalize and fix ISO format
      String cleanDate = _toEnglish(dateStr).replaceAll(' ', 'T');
      DateTime dateTime = DateTime.parse(cleanDate);

      // 2. Format using 12h clock
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
    final ThemeController themeController = Get.find<ThemeController>();
    final Color contentColor = themeController.themeMode.value == ThemeMode.light
        ? Colors.black
        : Colors.white;

    // Split the value to show only the whole number in the large display
    String displayValue = _toEnglish(value).split('.')[0];

    return GestureDetector(
      onTap: () {
        Get.to(() => VisibilityDetailsPage(), transition: Transition.rightToLeft);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeController.themeMode.value == ThemeMode.light
              ? Colors.white
              : const Color(0xFF3986DD),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Icon(icon, color: contentColor, size: 22),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: contentColor, fontSize: 16),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: contentColor),
              ],
            ),
            const SizedBox(height: 10),

            // Visibility Value Section
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _toBangla(displayValue),
                      style: TextStyle(
                        color: contentColor.withOpacity(themeController.themeMode.value == ThemeMode.light ? 0.7 : 1.0),
                        fontWeight: FontWeight.bold,
                        fontSize: 65,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(color: contentColor.withOpacity(0.7), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // Localized Description Subtitle
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                isBangla
                    ? '${formattedTime(start)} - ${formattedTime(end)} এর মধ্যে দৃষ্টিসীমার পরিমাণ ${_toBangla(value)} $unit'
                    : 'Visibility between ${formattedTime(start)} to ${formattedTime(end)} is $value $unit',
                style: TextStyle(
                  color: contentColor.withOpacity(0.8),
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
