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
                  isBangla ? 'অ্যাক্টিভিটি ইনডেক্স' : 'Activity Index',
                  style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white, fontSize: 18),
                ),
                Icon(Icons.arrow_drop_down, color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.black
                    : Colors.white,),
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
                  ? 'শিশু ও বৃদ্ধদের জ্বর, সর্দি, কাশি ও শ্বাসকষ্টজনিত রোগ থেকে রক্ষার জন্য বিশেষ খেয়াল রাখুন।  গরম কাপড় পরিধান করুন। '
                  : 'Take extra care of children and elderly to protect them from fever, cold, cough, and respiratory issues. Wear warm clothing.',
            ),

            // 2. Running / Exercise
            _buildIndicatorItem(
              Icons.warning_amber,
              isBangla
                  ? 'রাত হতে ভোর পর্যন্ত সড়ক ও নৌপথে যানবাহন চালানোর সময় সাবধানতা অবলম্বন করুন।'
                  : 'Excellent time for running outside; wear light winter gear.',
            ),

            // 3. Health (Cold/Flu)
            _buildIndicatorItem(
              Icons.agriculture,
              isBangla
                  ? 'শীতকালীন আবহাওয়ায় ফসল রক্ষায় সেচ, আবরণ এবং নিয়মিত পর্যবেক্ষণ জরুরি।'
                  : 'In winter weather, it is essential to irrigate, cover, and regularly monitor crops to protect them.',
            ),

            // 4. Flights
            _buildIndicatorItem(
              Icons.face_retouching_natural,
              isBangla
                  ? 'আবহাওয়ার কারণে চর্মরোগের ঝুঁকি বাড়ছে। ত্বকের যত্ন নিন।'
                  : 'The risk of skin diseases is increasing due to the weather. Take care of your skin.',
            ),

            // 5. Driving (Fog Warning)
            _buildIndicatorItem(
              Icons.drive_eta,
              isBangla
                  ? 'সকালের দিকে ঘন কুয়াশা থাকতে পারে, সাবধানে গাড়ি চালান।'
                  : 'There may be dense fog in the morning; drive carefully.',
            ),
          ],
        ),
      ),
    );
  }
}