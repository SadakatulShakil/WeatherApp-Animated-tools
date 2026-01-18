import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';

class ActivityIndicatorWidget extends StatelessWidget {
  ActivityIndicatorWidget({super.key});
  final ThemeController themeController = Get.find<ThemeController>();

  // 1. Helper to determine language
  bool get isBangla => Get.locale?.languageCode == 'bn';

  // 2. Widget for a single indicator item
  Widget _buildIndicatorItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
              icon,
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
              size: 24
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16
              ),
            ),
          ),
        ],
      ),
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
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Header ---
            Row(
              children: [
                Icon(Icons.info_outline, color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.black
                    : Colors.white,),
                SizedBox(width: 8),
                Text(
                  // You can add 'index' to your translation file or handle it here:
                  'index'.tr,
                  style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white, fontSize: 18),
                ),
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

            // --- Indicator List (Context-Aware for BD Winter) ---

            // 1. Outdoor Activities
            _buildIndicatorItem(
              Icons.medical_services_outlined,
              isBangla
                  ? 'শিশু বৃদ্ধ এবং বিশেষ চাহিদা সম্পন্ন ব্যক্তিদের জ্বর, সর্দি, কাশি ও শ্বাসকষ্টজনিত রোগ থেকে রক্ষার জন্য খেয়াল রাখুন।'
                  : 'Take special care to protect children, the elderly, and persons with special needs from fever, colds, coughs, and respiratory illnesses.',
            ),

            // 2. Running / Exercise
            _buildIndicatorItem(
              Icons.warning_amber,
              isBangla
                  ? 'শীত থেকে রক্ষার জন্য গরম কাপড় পরিধান করুন। লেপ, কম্বল এর পর্যাপ্ত ব্যবস্থা রাখুন।'
                  : 'Protect yourself from cold weather by wearing warm clothes and arranging sufficient bedding.',
            ),

            // 3. Healths
            _buildIndicatorItem(
              Icons.face_retouching_natural,
              isBangla
                  ? 'শীতকালীন আবহাওয়ায় চর্ম রোগ প্রতিরোধে পরিষ্কার পরিচ্ছন্নতা অবলম্বন করুন এবং ত্বকের যত্ন নিন।'
                  : 'Maintain proper hygiene and take care of your skin to prevent skin diseases during winter.',
            ),

            // 4. Flights
            _buildIndicatorItem(
              Icons.directions_walk,
              isBangla
                  ? 'কুয়াশার কারণে রাতে এবং সকালে যাতায়াতের ক্ষেত্রে বিশেষ সতর্কতা অবলম্বন করুন।'
                  : 'Travel carefully at night and in the early morning as fog may reduce visibility.',
            ),

            // 5. Driving (Fog Warning)
            _buildIndicatorItem(
              Icons.drive_eta,
              isBangla
                  ? 'খুব প্রয়োজন না হলে ভোরে ও রাতে বাইরে বের হওয়া থেকে বিরত থাকুন।'
                  : 'Avoid going outside early in the morning and at night unless it is absolutely necessary.',
            ),
          ],
        ),
      ),
    );
  }
}