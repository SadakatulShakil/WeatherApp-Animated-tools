import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_model.dart';
import '../services/api_urls.dart';
import 'package:intl/intl.dart';
import '../services/user_pref_service.dart'; // Import your model

class PrayerTimeController extends GetxController with StateMixin<PrayerModel> {

  final userService = UserPrefService();

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    // 1. Set state to loading immediately
    change(null, status: RxStatus.loading());

    try {
      final lang = userService.appLanguage;
      // Simulating API call using GetConnect (or use http/dio)
      final response = await http.get(
        Uri.parse(ApiURL.PRAYER_TIME),
        headers: {'Accept-Language': lang},
      );

      if (response.statusCode == 200) {

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);


        final data = PrayerModel.fromJson(jsonResponse);

        if (data.status == true && data.result != null) {
          change(data, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.empty());
        }
      } else {
        change(null, status: RxStatus.error("Server Error: ${response.statusCode}"));
      }
    } catch (e) {

      change(null, status: RxStatus.error("Connection failed: $e"));
    }
  }

  /// Helper to convert "18:30" or "06:30" to "06:30 PM"
  String? formatTime(String? time) {
    if (time == null || time.isEmpty) return "--:--";

    try {
      time = time.trim();

      DateTime parsedTime;

      if (time.contains("AM") || time.contains("PM")) {
        // Already has AM/PM, parse strictly to ensure formatting consistency
        parsedTime = DateFormat("h:mm a").parse(time);
      } else if (time.split(":").length == 3) {
        // Format is HH:mm:ss
        parsedTime = DateFormat("HH:mm:ss").parse(time);
      } else {
        // Format is HH:mm
        parsedTime = DateFormat("HH:mm").parse(time);
      }

      // 3. Format to "hh:mm a" (e.g., 06:30 PM)
      return DateFormat("hh:mm a").format(parsedTime);

    } catch (e) {
      // If parsing fails, just return the original string
      return time;
    }
  }
}