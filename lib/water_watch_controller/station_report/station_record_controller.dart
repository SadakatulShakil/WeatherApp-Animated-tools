import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../../water_watch_models/station_history_model.dart';

class StationRecordController extends GetxController {
  final userService = UserPrefService();
  final locationData = Get.arguments['item'];
  final type = Get.arguments['type'];
  final stationId = Get.arguments['item'].stationId ?? "";

  final selectedParameterId = "".obs; // update this when parameter changes
  final groupedRecordsByDate = <String, List<StationHistoryModel>>{}.obs;
  // final waterLevelGroupedRecordsByDate = <String, List<StationHistoryModel>>{}.obs;
  // final rainfallGroupedRecordsByDate = <String, List<StationHistoryModel>>{}.obs;
  final expandedDates = <String>{}.obs;

  final isLoading = false.obs;
  final errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    // auto load if stationId exists
    if (stationId.toString().isNotEmpty) {
      fetchStationHistory();
    }
  }

  /// Fetch last 7 days history from API
  Future<void> fetchStationHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final url =
          type == 'rainfall'
              ?ApiURL.RAINFALL_HISTORY
              :ApiURL.WATER_LEVEL_HISTORY;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${userService.userToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

       // final waterLevelRecords = jsonList.map((e) => StationHistoryModel.fromJson(e)).toList();
       //  // group by date
       //  final Map<String, List<StationHistoryModel>> waterLevelGrouped = {};
       //  for (var history in waterLevelRecords) {
       //    final dateKey =
       //    history.observationDate.toIso8601String().split("T")[0];
       //    waterLevelGrouped.putIfAbsent(dateKey, () => []).add(history);
       //  }
       //
       //  waterLevelGroupedRecordsByDate.value = waterLevelGrouped;

        final histories = jsonList
            .map((e) => StationHistoryModel.fromJson(e))
            .where((h) => h.station.toString() == stationId.toString()) // filter stationId
            .toList();

        // group by date
        final Map<String, List<StationHistoryModel>> grouped = {};
        for (var history in histories) {
          final dateKey =
          history.observationDate.toIso8601String().split("T")[0];
          grouped.putIfAbsent(dateKey, () => []).add(history);
        }

        groupedRecordsByDate.value = grouped;
      } else {
        errorMessage.value =
        "Failed to fetch history (code: ${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand(String date) {
    expandedDates.contains(date)
        ? expandedDates.remove(date)
        : expandedDates.add(date);
  }

  bool isDateExpanded(String date) => expandedDates.contains(date);

  Future<void> deleteRecord(int id) async {
    final url = Uri.parse(type == 'rainfall'
        ?"https://api3.ffwc.gov.bd/api/app_water_watch_mobile/rflevel/$id/delete/"
        :"https://api3.ffwc.gov.bd/api/app_water_watch_mobile/waterlevel/$id/delete/");
    try {
      final token = userService.userToken;
      final response = await http.delete(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print('Delete response status: $id - ${response.statusCode}');
      if (response.statusCode == 200) {
        Get.snackbar("সফল", "রেকর্ড মুছে ফেলা হয়েছে");
        await fetchStationHistory();
      }else if(response.statusCode == 400){
        Get.snackbar("ত্রুটি", "You can update only within 1 hour of creation");
      } else {
        Get.snackbar("ত্রুটি", "ডিলিট ব্যর্থ হয়েছে (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("ত্রুটি", "Error deleting record: $e");
    }
  }

  Future<void> onRefresh() async {
    await fetchStationHistory();
  }
}
