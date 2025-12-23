import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../../w_citizen_science_models/dashboard_model.dart';
import '../../w_citizen_science_models/profile_model.dart';
import '../../w_citizen_science_pages/mobile.dart';


class CitizenScienceDashboardController extends GetxController {

  final userService = UserPrefService();

  var initTime = "Good Morning".obs;
  late var fullname = "".obs;
  late var mobile = "".obs;
  late var email = "".obs;
  late var photo = "".obs;

  //weather
  dynamic notification = [].obs;
  var notificationValue = "".obs;

  var isLoading = false.obs;
  var dashboardModules = <DashboardModule>[].obs;


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
    fetchProfileData();
    fetchDashboardData();
  }

  void fetchProfileData() async{
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(ApiURL.USER_PROFILE_DETAILS),
        headers: {
          'Authorization': '${userService.userToken}',
          'Accept': 'application/json'
        },
      );

      print("Profile Response: ${response.statusCode}");
      final profileDecode = ProfileModel.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        fullname.value = profileDecode.result?.fullname ?? '';
        await userService.saveProfileData(
          profileDecode.result?.fullname ?? '',
          profileDecode.result?.email ?? '',
          profileDecode.result?.mobile ?? '',
          profileDecode.result?.address ?? '',
          profileDecode.result?.lat.toString() ?? '',
          profileDecode.result?.lon.toString() ?? '',
          profileDecode.result?.status.toString() ?? '',
          'https://t3.ftcdn.net/jpg/07/24/59/76/360_F_724597608_pmo5BsVumFcFyHJKlASG2Y2KpkkfiYUU.jpg',
        );

        print("Fetched profile: ${profileDecode.toJson()}");
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userService.refreshAccessToken();
        if (refreshed) {
          return fetchProfileData(); // Retry after refreshing the token
        } else {
          return Get.defaultDialog(
            title: "Session Expired",
            middleText: "Please log in again.",
            textCancel: 'Ok',
            onCancel: () {
              userService.clearUserData();
              Get.offUntil(
                GetPageRoute(page: () => CitizenScienceMobile(), transition: Transition.upToDown),
                    (route) => route.isFirst,
              );
            },
          );
        }
      } else {
        print("Failed to fetch locations, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    } finally {
      isLoading.value = false;
    }
  }
  void fetchDashboardData() async {
    try {
      isLoading.value = true;
      final lang = userService.appLanguage;
      final response = await http.get(
        Uri.parse(ApiURL.DASHBOARD_DETAILS),
        headers: {
          'Authorization': '${userService.userToken}',
          'Accept': 'application/json',
          'Accept-Language': lang,
        },
      );

      print('checkToken: ${userService.userToken}');
      print("Dash Response Code: ${response.statusCode}");
      print("Dash Response url: ${ApiURL.DASHBOARD_DETAILS}");

      if (response.statusCode == 200) {
        // 2. Parse using the new DashboardModel
        final data = DashboardModel.fromJson(jsonDecode(response.body));

        if (data.status == true && data.result != null) {
          // 3. Assign the list to your observable variable
          dashboardModules.value = data.result!;

          print("Fetched ${dashboardModules.length} modules");
        } else {
          print("API returned status false: ${data.message}");
        }
      }else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userService.refreshAccessToken();
        if (refreshed) {
          return fetchDashboardData(); // Retry after refreshing the token
        } else {
          return Get.defaultDialog(
            title: "Session Expired",
            middleText: "Please log in again.",
            textCancel: 'Ok',
            onCancel: () {
              userService.clearUserData();
              Get.offUntil(
                GetPageRoute(page: () => CitizenScienceMobile(), transition: Transition.upToDown),
                    (route) => route.isFirst,
              );
            },
          );
        }
      } else {
        print("Failed to fetch dashboard data, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
    } finally {
      isLoading.value = false;
    }
  }

}