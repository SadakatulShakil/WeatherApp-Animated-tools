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
              Icons.schedule,
              isBangla
                  ? 'বাইরের কার্যকলাপের জন্য আবহাওয়া আরামদায়ক, তবে ধুলোবালি এড়িয়ে চলুন।'
                  : 'Weather is comfortable for outdoor activities, but avoid dust.',
            ),

            // 2. Running / Exercise
            _buildIndicatorItem(
              Icons.directions_run,
              isBangla
                  ? 'বাইরে দৌড়ানোর জন্য চমৎকার সময়, হালকা শীতের পোশাক পরুন।'
                  : 'Excellent time for running outside; wear light winter gear.',
            ),

            // 3. Health (Cold/Flu)
            _buildIndicatorItem(
              Icons.medical_services_outlined,
              isBangla
                  ? 'তাপমাত্রা কমায় ঠান্ডা বা ফ্লু হওয়ার ঝুঁকি থাকতে পারে, সতর্ক থাকুন।'
                  : 'Risk of cold or flu due to temperature drop; stay cautious.',
            ),

            // 4. Flights
            _buildIndicatorItem(
              Icons.airplanemode_active,
              isBangla
                  ? 'উড়োজাহাজ চলাচলের জন্য আকাশ পরিষ্কার এবং পরিস্থিতি স্বাভাবিক।'
                  : 'Sky is clear and conditions are normal for flights.',
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