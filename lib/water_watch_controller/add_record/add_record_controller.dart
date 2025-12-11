import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../database_helper/db_service.dart';
import '../../database_helper/entity/local_parameter_entity.dart';
import '../../database_helper/entity/record_entity.dart';
import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../../water_watch_models/station_history_model.dart';
import '../dashboard/DashboardController.dart';

class AddRecordController extends GetxController {
  final userService = UserPrefService();
  final locationData = Get.arguments['item'];
  final type = Get.arguments['type'];
  final selectedImages = <File>[].obs;
  final selectedDate = DateTime.now().obs;
  final dbService = Get.find<DBService>();
  final timeMeasurements = <Map<String, dynamic>>[].obs;
  final Map<Map<String, dynamic>, TextEditingController> measurementControllers = {};/// controller for each measurement input
  final dashboardController = Get.find<WaterWatchDashboardController>();

  @override
  void onInit() {
    addTimeMeasurement(); // Initial row
    super.onInit();
  }


  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (picked != null) selectedDate.value = picked;
  }

  void updateMeasurementByItem(Map<String, dynamic> item, String value) {
    final index = timeMeasurements.indexOf(item);
    if (index != -1) {
      timeMeasurements[index]['measurement'] = value;
      timeMeasurements.refresh();
    }
  }


  ///------15 minute interval IOS time picker with AM/PM support------
  void pickCupertinoTime(Map<String, dynamic> item, BuildContext context) {
    DateTime now = DateTime.now();

    // 1. Get the current time and snap the minute to the nearest 15
    const int minuteInterval = 15;
    int currentMinute = now.minute;
    int snappedMinute = (currentMinute / minuteInterval).round() * minuteInterval;
    int snappedHour = now.hour;

    // Handle hour overflow if snapping rounded up to 60
    if (snappedMinute >= 60) {
      snappedMinute = 0;
      snappedHour = (snappedHour + 1) % 24;
    }

    // Create the initial DateTime with the snapped time
    DateTime initialDateTime = DateTime(now.year, now.month, now.day, snappedHour, snappedMinute);

    // This will hold the final selected DateTime
    DateTime selectedDateTime = initialDateTime;

    showCupertinoModalPopup<DateTime>( // Specify return type as DateTime
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300.h,
          color: CupertinoColors.darkBackgroundGray,
          child: Column(
            children: [
              // Done button
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  child: Text('ok'.tr, style: TextStyle(fontSize: 16.sp, color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop(selectedDateTime);
                  },
                ),
              ),
              // The picker using the DateTime mode for AM/PM
              SizedBox(
                height: 200.h,
                child: CupertinoDatePicker( // CupertinoDatePicker is used with .dateTime mode
                  mode: CupertinoDatePickerMode.time, // Use .time for Hour/Minute/AMPM
                  initialDateTime: initialDateTime,
                  // minuteInterval is applied here for 15-minute steps
                  minuteInterval: minuteInterval,
                  use24hFormat: false, // Explicitly set to false for 12-hour clock
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDateTime = newDateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        // Convert the final DateTime back to TimeOfDay
        final TimeOfDay finalTime = TimeOfDay.fromDateTime(value);

        // Format will now include AM/PM since TimeOfDay uses the device locale/settings
        String formatted = finalTime.format(context);

        final index = timeMeasurements.indexOf(item);
        if (index != -1) {
          timeMeasurements[index]['time'] = formatted;
          timeMeasurements.refresh();
        }
      }
    });
  }


  void pickTimeByItem(Map<String, dynamic> item, BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      String formatted = picked.format(context);
      final index = timeMeasurements.indexOf(item);
      if (index != -1) {
        timeMeasurements[index]['time'] = formatted;
        timeMeasurements.refresh();
      }
    }
  }

  void addTimeMeasurement() {
    final item = {'time': '', 'measurement': ''};
    timeMeasurements.add(item);
    measurementControllers[item] = TextEditingController();// create a new controller for this item
  }


  void removeTimeMeasurementByItem(Map<String, dynamic> item) {
    if (timeMeasurements.length > 1) {
      measurementControllers[item]?.dispose();// dispose the controller
      measurementControllers.remove(item);// remove the controller
      timeMeasurements.remove(item);// remove the item
    }
  }

  Future<void> pickImage() async {
    if (selectedImages.length >= 3) {
      Get.snackbar("সীমা অতিক্রম", "আপনি সর্বোচ্চ ৩টি ছবি আপলোড করতে পারবেন");
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (picked != null) {
      final File imageFile = File(picked.path);
      final File saved = await saveImageToLocalFolder(imageFile);
      selectedImages.add(saved);
    }
  }

  Future<File> saveImageToLocalFolder(File image) async {
    final dateStr = selectedDate.value.toString().split(" ")[0];
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/records/$dateStr');

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await image.copy('${folder.path}/$fileName');

    return savedImage;
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  List<String> getImagePaths() {
    return selectedImages.map((f) => f.path).toList();
  }

  void loadRecord(StationHistoryModel record) {
    selectedDate.value = DateTime(
      record.observationDate.year,
      record.observationDate.month,
      record.observationDate.day,
    );

    timeMeasurements.clear();
    measurementControllers.clear();

    print('checkTTTT: ${record.observationDate}');
    final formattedTime = DateFormat("hh:mm a").format(record.observationDate);
    final item = {
      'time': formattedTime,
      'measurement': record.waterLevel,
    };
    timeMeasurements.add(item);
    measurementControllers[item] = TextEditingController(text: record.waterLevel);

    update();
  }


  DateTime? _parseTime(String timeStr) {
    print('check_time: $timeStr');
    try {
      final cleanedTimeStr = timeStr.replaceAll(' ', ' ').trim();
      final normalizedTimeStr = cleanedTimeStr.replaceAll('.', ':');

      // Use a specific format that handles AM/PM correctly
      final DateFormat format = DateFormat("h:mm a"); // e.g., 4:49 PM

      DateTime parsedTime = format.parse(normalizedTimeStr);

      // Combine with selected date
      return DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        parsedTime.hour,  // This will already be in 24-hour format
        parsedTime.minute,
      );
    } catch (e) {
      print('Error parsing time "$timeStr": $e');
      return null;
    }
  }

  Future<bool> saveRecord({String mode = 'add', StationHistoryModel? record}) async {
    final stationId = locationData.stationId;

    if (timeMeasurements.isEmpty) {
      Get.snackbar("ত্রুটি", "অন্তত একটি সময় ও পরিমাপ যোগ করুন");
      return false;
    }

    // Validate entries & duplicate times
    final seenTimes = <String>{};
    for (var entry in timeMeasurements) {
      final time = entry['time']?.trim() ?? '';
      final measurement = entry['measurement']?.trim() ?? '';

      if (time.isEmpty || measurement.isEmpty) {
        Get.snackbar("অপূর্ণ তথ্য", "সময় এবং পরিমাপ পূরণ করুন");
        return false;
      }

      if (seenTimes.contains(time)) {
        Get.snackbar("ডুপ্লিকেট সময়", "একই সময় একাধিকবার দেয়া হয়েছে");
        return false;
      }

      seenTimes.add(time);
    }

    // Validate 15-min gap
    final parsedTimes = timeMeasurements
        .map((e) => _parseTime(e['time'] ?? ''))
        .whereType<DateTime>()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    for (int i = 1; i < parsedTimes.length; i++) {
      final diff = parsedTimes[i].difference(parsedTimes[i - 1]).inMinutes;
      if (diff < 15) {
        Get.snackbar("সময় খুব কাছাকাছি", "প্রতিটি রেকর্ডের মাঝে কমপক্ষে ১৫ মিনিট ব্যবধান রাখুন");
        return false;
      }
    }

    // Prepare payload
    final List<Map<String, dynamic>> payload = timeMeasurements.map((entry) {
      final parsedTime = _parseTime(entry['time']!);
      if (parsedTime == null) throw Exception('Invalid time format: ${entry['time']}');
      print('check_parTime: $parsedTime');
      return {
        "station_id": stationId,
        "observation_date": parsedTime.toIso8601String(),
        "water_level": entry['measurement'],
        // "images": getImagePaths(), // optional
      };
    }).toList();

    print("Prepared payload: $payload");

    try {
      final token = userService.userToken;
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      if (mode == 'update' && record != null) {
        final id = record.id;
        final url = Uri.parse(
          type == 'rainfall'
              ? "${ApiURL.RAINFALL_RECORD_UPDATE_BASE}$id/update/"
              : "${ApiURL.WATER_LEVEL_RECORD_UPDATE_BASE}$id/update/",
        );

        final response = await http.put(url, headers: headers, body: jsonEncode(payload.first));

        if (response.statusCode == 200) {
          Get.snackbar("সফল", "রেকর্ড সফলভাবে হালনাগাদ হয়েছে");
          return true;
        } else if (response.statusCode == 403) {
          Get.snackbar("ত্রুটি", "You can update only within 1 hour of creation");
          return false;
        } else {
          Get.snackbar("ত্রুটি", "আপডেট ব্যর্থ (code: ${response.statusCode})");
          return false;
        }
      } else {
        final url = Uri.parse(
          type == 'rainfall'
              ? ApiURL.RAINFALL_RECORD_CREATE
              : ApiURL.WATER_LEVEL_RECORD_CREATE,
        );

        final response = await http.post(url, headers: headers, body: jsonEncode(payload));

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar("সফল", "রিপোর্ট সফলভাবে পাঠানো হয়েছে");
          return true;
        } else {
          Get.snackbar("ত্রুটি", "API পাঠাতে ব্যর্থ (code: ${response.statusCode})");
          return false;
        }
      }
    } catch (e) {
      Get.snackbar("ত্রুটি", "API পাঠাতে ব্যর্থ: $e");
      return false;
    } finally {
      if (mode == 'add') {
        selectedImages.clear();
        for (var c in measurementControllers.values) {
          c.dispose();
        }
        measurementControllers.clear();
        timeMeasurements.clear();
        addTimeMeasurement();
      }
    }
  }

  @override
  void onClose() {
    measurementControllers.values.forEach((c) => c.dispose());
    super.onClose();
  }

}
