import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';

class AirQualityDetailsWidget extends StatelessWidget {
  AirQualityDetailsWidget({super.key});
  final ThemeController themeController = Get.find<ThemeController>();
  // Widget for a single AQI category block
  Widget _buildAqiCategory({
    required String status,
    required String range,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFF268CC8), width: 1),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            status, // ভালো, মাঝারি, etc.
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const SizedBox(height: 5),
          // Range Text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              range, // ভালো, মাঝারি, etc.
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          // Description Text
          Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: const Text('বাতাসের মান'),
        elevation: 0,
        leading:  GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              _buildAqiCategory(
                status: 'ভালো',
                range: '০-৫০',
                color: Colors.green,
                description:
                'বাতাসের মান সন্তোষজনক বলে মনে করা হচ্ছে, এবং বায়ু দূষণের ঝুঁকি খুব কম বা একেবারেই নেই।',
              ),
              _buildAqiCategory(
                status: 'মাঝারি',
                range: '৫১-১০০',
                color: Colors.yellow.shade700,
                description:
                'বায়ু এখন গ্রহণযোগ্য; তবে, কিছু দূষণকারীর ক্ষেত্রে বায়ুর প্রতি অস্বাভাবিকভাবে সংবেদনশীল সুস্থ মানুষের ক্ষেত্রে মাঝারি আঘাত ঘটতে পারে। হাঁপানি এবং অন্যান্য শ্বাসযন্ত্রের রোগে আক্রান্ত ব্যক্তিদের, দীর্ঘক্ষণ বাইরের পরিশ্রমে সীমিত করা উচিত।',
              ),
              _buildAqiCategory(
                status: 'সংবেদনশীল গোষ্ঠীর জন্য অস্বাস্থ্যকর',
                range: '১০১-১৫০',
                color: Colors.orange,
                description:
                'সংবেদনশীল গোষ্ঠীর সদস্যরা স্বাস্থ্যের উপর প্রভাব অনুভব করতে পারে; সংবেদনশীল গোষ্ঠীর সদস্যরা সাধারণ জনতার অভ্যন্তরেও খারাপ প্রভাব অনুভব করতে পারে। দীর্ঘক্ষণ বাইরের পরিশ্রমে সীমিত করা উচিত।',
              ),
              _buildAqiCategory(
                status: 'অস্বাস্থ্যকর',
                range: '১৫১-২০০',
                color: Colors.red,
                description:
                'সংবেদনশীল গোষ্ঠীর সদস্যরা স্বাস্থ্যের উপর প্রধান প্রভাব ফেলতে পারে। সাধারণ জনগণ এর দ্বারা আক্রান্ত হওয়ার সম্ভাবনা কম। দীর্ঘক্ষণ বাইরের পরিশ্রমে সীমিত করা উচিত।',
              ),
              _buildAqiCategory(
                status: 'খুবই অস্বাস্থ্যকর',
                range: '২০১-৩০০',
                color: const Color(0xFF8B0000), // Dark Red/Maroon
                description:
                'অবস্থা অত্যন্ত অস্বাস্থ্যকর। সমগ্র জনসংখ্যার আক্রান্ত হওয়ার সম্ভাবনা বেশি। সকলকেই, বিশেষ করে শিশুদের, বাইরের পরিশ্রমে সীমিত করা উচিত।',
              ),
            ],
          ),
        ),
      ),
    );
  }
}