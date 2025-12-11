import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../database_helper/entity/local_parameter_entity.dart';
import '../dashboard/DashboardController.dart';

class SmsController extends GetxController {

  final selectedStation = Rx<dynamic>(null); // can be WaterLevelStation or RainfallStation
  final selectedParameter = Rx<ParameterEntity?>(null);
  final selectedDate = DateTime.now().obs;
  final timeMeasurements = <Map<String, String>>[].obs;

  final dashboard = Get.find<WaterWatchDashboardController>();

  List<dynamic> get availableStations {
    if (selectedParameter.value?.title.toLowerCase() == "rainfall" ||
        selectedParameter.value?.titleBn == "বৃষ্টিপাত") {
      return dashboard.rainfallStation;
    } else {
      return dashboard.waterLevelStation;
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (dashboard.parameters.isNotEmpty) {
      // Default select Rainfall
      selectedParameter.value = dashboard.parameters.firstWhere(
            (p) => p.title.toLowerCase() == "rainfall",
        orElse: () => dashboard.parameters.first,
      );
    }

    // Set first station of that parameter
    if (availableStations.isNotEmpty) {
      selectedStation.value = availableStations.first;
    }

    addTimeMeasurement(); // Initial row
  }

  void updateStationList() {
    if (availableStations.isNotEmpty) {
      selectedStation.value = availableStations.first;
    } else {
      selectedStation.value = null;
    }
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

  void updateMeasurementByItem(Map<String, String> item, String value) {
    final index = timeMeasurements.indexOf(item);
    if (index != -1) {
      timeMeasurements[index]['measurement'] = value;
      timeMeasurements.refresh();
    }
  }

  void pickTimeByItem(Map<String, String> item, BuildContext context) async {
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
    timeMeasurements.add({'time': '', 'measurement': ''});
  }

  void removeTimeMeasurementByItem(Map<String, String> item) {
    if (timeMeasurements.length > 1) {
      timeMeasurements.remove(item);
    }
  }

  void saveRecord() {
    final station = selectedStation.value;
    final param = selectedParameter.value;

    if (station == null || param == null) {
      Get.snackbar("Missing Data", "স্টেশন ও প্যারামিটার নির্বাচন করুন");
      return;
    }

    // Validate each timeMeasurement entry
    for (var entry in timeMeasurements) {
      final time = entry['time']?.trim() ?? '';
      final measurement = entry['measurement']?.trim() ?? '';
      if (time.isEmpty || measurement.isEmpty) {
        Get.snackbar("অপূর্ণ তথ্য", "সময় এবং পরিমাপ পূরণ করুন");
        return;
      }
    }

    final date = "${selectedDate.value.toLocal()}".split(' ')[0];
    final report = timeMeasurements.map((entry) {
      final time = entry['time'] ?? "";
      final measurement = entry['measurement'] ?? "";
      return "$date: $time: ${param.title} - $measurement মিমি";
    }).join("; ");

    final message = "তারিখ: $date\nস্টেশন: ${station.nameBn} (${station.stationId})\nপ্যারামিটার: ${param.title} (${param.id})\nরিপোর্ট: $report";

    final smsUri = Uri(
      scheme: 'sms',
      path: "01751330394",
      queryParameters: {'body': message},
    );

    print("SMS URI: $report");
    launchUrl(smsUri);
  }
}
