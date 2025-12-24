import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../models/forecast_model.dart';
import 'api_urls.dart';
import 'user_pref_service.dart';

class LocationService {
  /// Fetch location and call API, callback triggers when settings opened
  Future getLocation({required VoidCallback onSettingsOpened, int timeoutSeconds = 5}) async {
    try {
      final position = await _getCurrentLocation(onSettingsOpened);
      print("DEBUG: Got position -> Lat:${position.latitude}, Lon:${position.longitude}");

      // Call your API with the coordinates
      final response = await http.get(
        Uri.parse("${ApiURL.LOCATION_LATLON}?type=point&lat=${position.latitude}&lon=${position.longitude}"),
        headers: {'Accept-Language': Get.locale?.languageCode ?? 'bn'},
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final forecast = WeatherForecastModel.fromJson(data);
        await UserPrefService().saveLocationData(
          position.latitude.toStringAsFixed(5),
          position.longitude.toStringAsFixed(5),
          forecast.result?.location?.id ?? 'Unknown',
          forecast.result?.location?.locationName ?? 'Unknown',
          forecast.result?.location?.districtBn ?? 'Unknown',
          forecast.result?.location?.upazilaBn ?? 'Unknown',
        );
        print("✅ Location data saved with name: ${data['result']['name']}");
      } else {
        // fallback save lat/lon only
        await UserPrefService().saveLatLonData(
          position.latitude.toStringAsFixed(5),
          position.longitude.toStringAsFixed(5),
        );
        print("⚠ Location API failed, saved lat/lon only");
      }
    } catch (e) {
      print("❌ Location fetch/API failed: $e");
      rethrow;
    }

  }

  /// Internal: handle permission + GPS + Google Accuracy
  Future _getCurrentLocation(VoidCallback onSettingsOpened) async {
// Step 1: Ensure device location (GPS) is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showModernDialog(
        title: "Enable Device Location",
        message: "Your device location is turned off. Please enable GPS.",
        confirmText: "Open Settings",
        cancelText: "Cancel",
        onConfirm: () async {
          Get.back();
          onSettingsOpened();
          await Geolocator.openLocationSettings();
        },
      );
      throw Exception("Device location disabled");
    }

// Step 2: Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    print("DEBUG: Permission status is: $permission");

    if (permission == LocationPermission.deniedForever) {
      await _showModernDialog(
        title: "Permission Blocked",
        message: "Location permission is permanently denied. Open App Settings.",
        confirmText: "Open App Settings",
        cancelText: "Cancel",
        onConfirm: () async {
          Get.back();
          await openAppSettings();
        },
      );
      throw Exception("Permission denied forever");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw Exception("Location permission denied by user");
      }
    }

// Step 3: Now get current position (may trigger "Improve Accuracy" dialog)
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).timeout(const Duration(seconds: 10));

  }

  /// Modern custom dialog
  Future _showModernDialog({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
  }) async {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(title,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    onPressed: onConfirm,
                    child: Text(confirmText,
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

}