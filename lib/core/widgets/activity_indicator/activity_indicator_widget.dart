import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';

class ActivityIndicatorWidget extends StatelessWidget {
  ActivityIndicatorWidget({super.key});
  final ThemeController themeController = Get.find<ThemeController>();

  // Widget for a single indicator item
  Widget _buildIndicatorItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Header: Indicators ---
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'সূচকসমূহ',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
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

              // --- Indicator List ---
              _buildIndicatorItem(
                Icons.schedule,
                'বাইরের কার্যকলাপের জন্য পরিস্থিতি ভালো থাকবে।',
              ),
              _buildIndicatorItem(
                Icons.directions_run,
                'বাইরে দৌড়ানোর জন্য অবস্থা অবশ্যই ভালো।',
              ),
              _buildIndicatorItem(
                Icons.medical_services_outlined, // DNA/Health icon placeholder
                'আবহাওয়া অবস্থার ঠান্ডা লাগার ঝুঁকি কম করে এবং জমাট বাঁধার তীব্রতা কমাতে এবং সময়কাল কমাতে সাহায্য করবে।',
              ),
              _buildIndicatorItem(
                Icons.airplanemode_active,
                'উড়ানের জন্য অবস্থা চমৎকার!',
              ),
              _buildIndicatorItem(
                Icons.drive_eta,
                'গাড়ি চালানোর অবস্থা মোটামুটি ভালো।',
              ),
            ],
          ),
        ),
      ),
    );
  }
}