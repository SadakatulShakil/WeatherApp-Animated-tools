import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../database_helper/db_service.dart';
import '../../database_helper/entity/local_location_entity.dart';
import '../../database_helper/entity/local_parameter_entity.dart';
import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../../water_watch_models/assign_rainfall_model.dart';
import '../../water_watch_models/assign_station_model.dart';
import '../../water_watch_models/profile_model.dart';

class WaterWatchDashboardController extends GetxController {

  final userService = UserPrefService();

  var initTime = "Good Morning".obs;
  late var fullname = "".obs;
  late var mobile = "".obs;
  late var email = "".obs;
  late var photo = "".obs;

  //weather
  var currentLocationId = "".obs;
  var currentLocationName = "".obs;
  dynamic forecast = [].obs;
  dynamic notification = [].obs;
  var notificationValue = "".obs;
  var cLocationUpazila = "".obs;
  var cLocationDistrict = "".obs;
  var isForecastLoading = false.obs;
  var isLoading = false.obs;
  var waterLevelStation = <WaterLevelStation>[].obs;
  var rainfallStation = <RainfallStation>[].obs;
  var parameters = <ParameterEntity>[].obs;
  final dbService = Get.find<DBService>();

  @override
  void onInit() {
    super.onInit();
    getTime();
    getDashBoardData();
  }

  Future onRefresh() async {
    await getTime();
    await getDashBoardData();
  }

  getTime() {
    var currentHour = DateTime.timestamp();
    var hour = int.parse(currentHour.toString().substring(11, 13)) + 6;
    if(hour > 23) {
      hour = hour - 23;
    }
    if (hour >= 5 && hour < 12) {
      initTime.value = "dashboard_time_good_morning".tr;
    } else if (hour >= 12 && hour < 15) {
      initTime.value = "dashboard_time_good_noon".tr;
    } else if (hour >= 15 && hour < 17) {
      initTime.value = "dashboard_time_good_afternoon".tr;
    } else if (hour >= 17 && hour < 19) {
      initTime.value = "dashboard_time_good_evening".tr;
    } else {
      initTime.value = "dashboard_time_good_night".tr;
    }
  }

  Future getDashBoardData() async {
    //await dbService.fetchAndSaveMasterQuestions();
    fetchProfileData();
    fetchWaterLevelStations();
    fetchRainfallStations();
    fetchParameters();
    //print("Current Location ID: ${currentLocationId.value}");

  }

  void fetchProfileData() async{
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(ApiURL.USER_PROFILE_DETAILS),
        headers: {
          'Authorization': 'Bearer ${userService.userToken}',
          'Accept': 'application/json'
        },
      );

      print("Profile Response: ${response.statusCode}");
      final profileDecode = ProfileModel.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        fullname.value = profileDecode.fullName;
        await userService.saveProfileData(
          profileDecode.firstName ?? '',
          profileDecode.lastName ?? '',
          profileDecode.fullName ?? '',
          profileDecode.address ?? '',
          profileDecode.lat.toString() ?? '',
          profileDecode.long.toString() ?? '',
          profileDecode.profileImage ?? '',
        );

        print("Fetched profile: ${profileDecode.toJson()}");
      } else {
        print("Failed to fetch locations, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    } finally {
      isLoading.value = false;
    }
  }
  void fetchWaterLevelStations() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(ApiURL.LOGGEDIN_WATER_LEVEL_STATION),
        headers: {
          'Authorization': 'Bearer ${userService.userToken}',
          'Accept': 'application/json'
        },
      );

      print("Locations Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Parse AssignStationModel
        final fetched = data.map((item) => AssignStationModel.fromJson(item)).toList();

        // Extract WaterLevelStation list
        waterLevelStation.value = fetched.map((assign) => assign.waterLevelStation).toList();

        print("Fetched Locations: ${waterLevelStation.length}");
      } else {
        print("Failed to fetch locations, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    } finally {
      isLoading.value = false;
    }
  }
  void fetchRainfallStations() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(ApiURL.LOGGEDIN_RAINFALL_STATION),
        headers: {
          'Authorization': 'Bearer ${userService.userToken}',
          'accept': 'application/json'
        },
      );

      print("Locations Response: ${response.statusCode}");
      print("Locations_Response: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Parse AssignStationModel
        final fetched = data.map((item) => AssignRainfallStation.fromJson(item)).toList();

        // Extract WaterLevelStation list
        rainfallStation.value = fetched.map((assign) => assign.rainfallStation).toList();

        print("Fetched Locations: ${rainfallStation.length}");
      } else {
        print("Failed to fetch locations, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchParameters() async {
    try {
      if (parameters.isEmpty) {
        final fetched = [
          ParameterEntity(id: '1',title: 'Rainfall', titleBn: 'বৃষ্টিপাত'),
          ParameterEntity(id: '2',title: 'Water Level', titleBn: 'পানির স্তর'),
        ];
        await dbService.saveParameters(fetched);
        parameters.value = fetched;
      } else {
        parameters.value = await dbService.loadParameters();
      }
    } catch (e) {
      parameters.value = await dbService.loadParameters();
    }
  }

  String getStationNameById(String id) {
    final station = waterLevelStation.firstWhereOrNull(
          (s) => s.stationId.toString() == id.toString()
    );
    return Get.locale?.languageCode == 'bn'
        ? (station?.nameBn ?? "অজানা স্টেশন")
        : (station?.name ?? "Unknown Station");
  }

}