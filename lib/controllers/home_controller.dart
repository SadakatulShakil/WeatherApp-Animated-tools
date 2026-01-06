import 'dart:convert';

import 'package:bmd_weather_app/core/widgets/forecast_widget/weekly_forecast_widget.dart';
import 'package:bmd_weather_app/models/forecast_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/widgets/others/custom_location_selection_page.dart';
import '../models/hourly_weather_model.dart';
import '../models/notification_model.dart';
import '../models/saved_location_model.dart';
import '../models/upazila_list_model.dart';
import '../models/user_survey_model.dart';
import '../models/weekly_forecast_model.dart';
import '../services/api_urls.dart';
import '../services/user_pref_service.dart';
import '../utills/app_color.dart';
import 'package:intl/intl.dart';

enum HomeSection {
  weather_Forecast,
  weekly_Forecast,
  wind_Pressure,
  other_Info,
  sun_Moon,
  air_Quality,
  activity_Indicator,
  prayer_Time,
}

class HomeController extends GetxController {
  var selectedLocation = 'Current Location'.obs;
  var sectionOrder = <HomeSection>[].obs;
  var sectionVisibility = <HomeSection, bool>{}.obs;
  var isLoaded = false.obs;
  static const String _storageKey = 'sectionOrder';
  static const String _storageKeyVisibility = 'sectionVisibility';

  RxList<Question> questions = <Question>[].obs;
  RxMap<int, String> answers = <int, String>{}.obs;
  final RxInt currentIndex = 0.obs;

  final currentLocationId = ''.obs;
  final currentLocationName = ''.obs;
  final cLocationUpazila = ''.obs;
  final cLocationDistrict = ''.obs;
  var lat = ''.obs;
  var lon = ''.obs;
  final RxBool isForecastFetched = false.obs;
  final RxBool isForecastLoading = false.obs;
  final Rxn<WeatherForecastModel> forecast = Rxn<WeatherForecastModel>();
  final savedLocations = <SavedLocation>[].obs;

  var dashboardAlertMessage = "".obs; // For Home Page Marquee
  var notificationList = <NotificationItem>[].obs;
  var isNotificationLoading = false.obs;
  var isNotificationError = false.obs;

  final userService = UserPrefService();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    await loadSectionOrder();
    await fetchNotifications();
    await loadVisibilitySettings();
    await loadQuestions();
    await getSharedPrefData();

    isLoaded.value = true;  // IMPORTANT
  }

  Future<void> getSharedPrefData() async {
    currentLocationId.value = userService.locationId ?? '';
    //currentLocationName.value = userService.locationName ?? 'Current Location';
    cLocationDistrict.value = userService.locationDistrict ?? '';
    cLocationUpazila.value = userService.locationUpazila ?? '';
    lat.value = userService.lat ?? '';
    lon.value = userService.lon ?? '';

    //selectedLocation.value = currentLocationName.value;

    print('🔥Pref Loaded Location: ${currentLocationName.value}');
    print('🔥Pref Loaded LocationID: ${currentLocationId.value}');

    if (currentLocationId.value.isNotEmpty) {
      await getForecast(lat.value, lon.value);
    } else {
      await getForecast(lat.value, lon.value);
      // If no locationId, you may still want to call forecast by lat/lon; that depends on your API
      //await getForecastByLatLon(lat.value, lon.value);
    }
  }

  Future<void> getForecast(String lat, String lon) async {
    print('location changeed @@@@@@');
    isForecastLoading.value = true;

    try {
      final lang = userService.appLanguage;
      print('getLanguageCode: $lang');

      final response = await http.get(
        Uri.parse("${ApiURL.CURRENT_FORECAST}lat=$lat&lon=$lon"),
        headers: {'Accept-Language': lang},
      );

      print('🔥 Forecast API Url : ${ApiURL.CURRENT_FORECAST}lat=$lat&lon=$lon');
      print('🔥 Forecast API Response Code : ${response.statusCode}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('🔥 Forecast fetched for location: ${json.toString()}');
        forecast.value = WeatherForecastModel.fromJson(json);
        currentLocationName.value = forecast.value?.result?.location?.locationName ?? currentLocationName.value;
        selectedLocation.value = currentLocationName.value;
        print('🔥 Forecast fetched for location: ${forecast.value?.result?.location?.locationName}');

        isForecastFetched.value = true;
      } else {
        isForecastFetched.value = false;
        Get.snackbar("error".tr, "error_msg1".tr);
      }
    } catch (e) {
      print("🔥 Error Parsing JSON: $e");
      isForecastFetched.value = false;
      Get.snackbar("error".tr, "error_msg2".tr);
    } finally {
      isForecastLoading.value = false;
    }
  }

// In controllers/home_controller.dart

  List<HourlyWeatherModel> getHourlyFromSteps() {
    print('location changeed ###');
    final result = forecast.value?.result;
    final steps = result?.steps;
    // Access the chart data we defined in the model
    final chart = result?.stepsChart;

    if (steps == null || steps.isEmpty) return [];

    return List.generate(steps.length, (index) {
      final step = steps[index];

      // Safely get values from the chart arrays
      // We check if 'chart' exists and if the index is valid for each array
      double temp = 0.0;
      double rain = 0.0;
      double humidity = 0.0;
      double wind = 0.0;

      if (chart != null) {
        if (chart.tempValAvg != null && index < chart.tempValAvg!.length) {
          temp = chart.tempValAvg![index];
        }
        if (chart.rfValAvg != null && index < chart.rfValAvg!.length) {
          rain = chart.rfValAvg![index];
        }
        if (chart.rhValAvg != null && index < chart.rhValAvg!.length) {
          humidity = chart.rhValAvg![index];
        }
        if (chart.windValAvg != null && index < chart.windValAvg!.length) {
          wind = chart.windValAvg![index];
        }
      } else {
        // Fallback to the individual step object if chart data is missing
        temp = 0.0;
        rain = 0.0;
        humidity = 0.0;
        wind = 0.0;
      }

      return HourlyWeatherModel(
        time: _formatHour(step.stepStart),
        iconKey: step.icon ?? 'ic_sunny_cloud.png',
        temp: temp,
        rainAmount: rain,
        humidity: humidity,
        windSpeed: wind,
        index: index,
      );
    });
  }

  String _formatHour(String? raw) {
    if (raw == null || raw.isEmpty) return '--:--';
    try {
      // Example: "2025-12-17 06:00:00" -> "06:00"
      return raw.split(' ').last.substring(0, 5);
    } catch (e) {
      return raw;
    }
  }

  // inside HomeController

  List<WeeklyForecastItem> getWeeklyForecast() {
    print('location changeed %%%%%%');
    final result = forecast.value?.result;
    final dailys = result?.daily;
    final chart = result?.dailyChart; // Access the chart data model

    if (dailys == null || dailys.isEmpty) return [];

    return List.generate(dailys.length, (index) {
      final daily = dailys[index];

      // // 1. Initialize with values from the standard daily object
      double minTemp =  0.0;
      double maxTemp =  0.0;

      // 2. Override with precise Chart Data if available
      if (chart != null) {
        if (chart.tempValMin != null && index < chart.tempValMin!.length) {
          minTemp = chart.tempValMin![index];
        }
        if (chart.tempValMax != null && index < chart.tempValMax!.length) {
          maxTemp = chart.tempValMax![index];
        }
      }

      return WeeklyForecastItem(
        _formatDate(daily.date), // e.g., "17 Dec, 2025"
        daily.weekday ?? '', // e.g., "Wednesday"
        minTemp,
        maxTemp,
        daily.icon ?? 'ic_sunny.png',
      );
    });
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '--:--';
    try {
      // Example: "2025-12-17 06:00:00" -> "17 Dec, 2025"
      final parts = raw.split(' ');
      final datePart = parts[0]; // "2025-12-17"
      final dateComponents = datePart.split('-');
      final year = dateComponents[0];
      final month = int.parse(dateComponents[1]);
      final day = dateComponents[2];

      const monthNames = [
        '', // Placeholder for 0 index
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];



      return '$day ${monthNames[month]}, $year';
    } catch (e) {
      return raw;
    }
  }

  Future<void> fetchNotifications() async {
    String? token = userService.userToken;
    isNotificationLoading.value = true;
    isNotificationError.value = false;

    try {
      final lang = userService.appLanguage;

      final response = await http.get(
        Uri.parse(ApiURL.NOTIFICATION_LIST),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': lang
        },
      );

      if (response.statusCode == 200) {
        final data = notificationModelFromJson(response.body);

        if (data.status == true && data.result != null) {
          // 1. Set Dashboard Message
          dashboardAlertMessage.value = data.result?.dashboardNotification ?? "";

          // 2. Set List
          notificationList.assignAll(data.result?.notification ?? []);
        }
      } else {
        print("Error fetching notifications: ${response.statusCode}");
        isNotificationError.value = true;
      }
    } catch (e) {
      print("Exception fetching notifications: $e");
      isNotificationError.value = true;
    } finally {
      isNotificationLoading.value = false;
    }
  }

  // Helper for Date Formatting (e.g., "27 Dec, 07:45 PM")
  String formatNotificationDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(rawDate);
      return DateFormat("dd MMM, hh:mm a").format(dt);
    } catch (e) {
      return rawDate;
    }
  }

  /// This method is called when the user reorders the sections in the dashboard.
  void updateSectionOrder(List<HomeSection> newOrder) async {
    sectionOrder.value = newOrder;
    await saveSectionOrder();
  }

  void updateSectionVisibility(HomeSection section, bool isVisible) async {
    sectionVisibility[section] = isVisible;
    await saveVisibilitySettings();
  }

  Future<void> saveSectionOrder() async {
    final prefs = await SharedPreferences.getInstance();
    ///Convert a list of enum values to a list of strings for sharedPreference storage, because sharedPreference
    ///can only store strings.
    ///TIPS: e.name is the string of the enum value.
    List<String> orderAsString = sectionOrder.map((e) => e.name).toList();
    await prefs.setStringList(_storageKey, orderAsString);
  }

  /// This method loads the section order from shared preferences when the app starts.
  Future<void> loadSectionOrder() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedOrder = prefs.getStringList(_storageKey);

    if (savedOrder != null && savedOrder.isNotEmpty) {
      sectionOrder.value = savedOrder.map((name) => _stringToHomeSection(name)).toList();
    } else {
      /// Default Order(If there is no saved order in sharedPreference)
      sectionOrder.value = [
        HomeSection.weather_Forecast,
        HomeSection.weekly_Forecast,
        HomeSection.wind_Pressure,
        HomeSection.other_Info,
        HomeSection.sun_Moon,
        HomeSection.air_Quality,
        HomeSection.activity_Indicator,
        HomeSection.prayer_Time,
      ];
    }
  }

  /// Saves the visibility settings of each section to shared preferences.
  Future<void> saveVisibilitySettings() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> map = {
      for (var entry in sectionVisibility.entries) entry.key.name: entry.value.toString()
    };
    await prefs.setString(_storageKeyVisibility, jsonEncode(map));
  }

  /// Loads the visibility settings of each section from shared preferences.
  Future<void> loadVisibilitySettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? raw = prefs.getString(_storageKeyVisibility);
    if (raw != null) {
      Map<String, dynamic> map = jsonDecode(raw);
      sectionVisibility.value = {
        for (var entry in map.entries)
          _stringToHomeSection(entry.key): entry.value == 'true'
      };
    } else {
      // Default: all visible
      sectionVisibility.value = {
        for (var section in HomeSection.values) section: true
      };
    }
  }

  ///Converts a string (e.g., "sunMoon") back to the corresponding enum value.
  ///Uses firstWhere to match the name of the enum value.
  HomeSection _stringToHomeSection(String name) {
    return HomeSection.values.firstWhere((e) => e.name == name, orElse: () => HomeSection.weather_Forecast);
  }

  /// Load data from API (your static JSON for now)

  Future loadQuestions() async{
    final List<Map<String, dynamic>> apiData = [
      {
        "id": 1,
        "question": "আজকে আপনার এলাকায় বৃষ্টিপাতের অবস্থা কেমন?",
        "options": ["কোন বৃষ্টিপাত নেই", "সামান্য বৃষ্টিপাত আছে", "ঝড়ো বৃষ্টি হচ্ছে", "ভারি বৃষ্টি হচ্ছে"]
      },
      {
        "id": 2,
        "question": "আজকের তাপমাত্রা কেমন মনে হচ্ছে?",
        "options": ["ঠান্ডা", "গরম", "খুব গরম", "ঠান্ডা ও গরমের মাঝামাঝি"]
      },
      {
        "id": 3,
        "question": "আপনার এলাকায় বন্যার পরিস্থিতি কেমন?",
        "options": ["আগের থেকে অবস্থার উন্নত হয়েছে", "কোন পরিবর্তন নেই", "আগের থেকে অবস্থার অবনতি হয়েছে"]
      },
      {
        "id": 4,
        "question": "আজকে আপনার এলাকায় বজ্রপাতের অবস্থা কেমন?",
        "options": ["একবার বা দুইবার হয়েছে", "আজকে হয় নাই", "বজ্রপাতের সাথে ভারি বৃষ্টি হচ্ছে"]
      },
    ];

    questions.value =
        apiData.map((e) => Question.fromJson(e)).toList();
  }

  /// select/update answer for question id
  void selectAnswer(int questionId, String option) {
    answers[questionId] = option;
    // reactive update happens automatically since answers is RxMap
  }

  /// get selected answer for current question
  String? selectedForCurrent() {
    if (questions.isEmpty) return null;
    final q = questions[currentIndex.value];
    return answers[q.id];
  }

  /// go to next question, but don't exceed length
  void next() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  /// go to previous question
  void previous() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  /// whether on last question
  bool get isLast => currentIndex.value == questions.length - 1;

  /// submit answers: validate all answered, then show snackbar formatted
  void submitAndShowSnackbar() {
    // require all questions answered
    if (answers.length != questions.length) {
      Get.snackbar(
        "ত্রুটি",
        "অনুগ্রহ করে সকল প্রশ্নের উত্তর দিন",
        snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
      );
      return;
    }

    // format number-wise (use question id order or index order)
    final List<String> lines = [];
    for (var q in questions) {
      final ans = answers[q.id] ?? '';
      lines.add("${q.id}. $ans");
    }
    final formatted = lines.join("\n");

    // close dialog first (caller should call Get.back() after invoking this OR we can pop here)
    // We'll pop here to be safe if dialog is open:
    if (Get.isDialogOpen ?? false) Get.back();

    // show top snackbar with only numbered answers in message
    Get.snackbar(
      '',
      formatted,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      // styling to look like simple toast (no title)
      titleText: const SizedBox.shrink(),
      messageText: Text(
        formatted,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF0B72A6),
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
      borderRadius: 8,
    );
  }


  /// Load saved locations from UserPrefService
  Future<void> loadSavedLocations() async {
    try {
      final list = await userService.getSavedLocations();
      savedLocations.assignAll(list);

      // Ensure selectedLocation reflects the current saved/current
      selectedLocation.value = currentLocationName.value.isNotEmpty
          ? currentLocationName.value
          : (savedLocations.isNotEmpty ? savedLocations.first.displayName : 'Current Location');

    } catch (e) {
      debugPrint("Error loading saved locations: $e");
    }
  }

  /// Call this to open the bottom-sheet selector (used by the UI)
  Future<void> openLocationSelector() async {
    // refresh the saved list before showing
    await loadSavedLocations();

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors().app_secondary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        height: MediaQuery.of(Get.context!).size.height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text("location_list".tr, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors().black_font_color, fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                if (savedLocations.isEmpty) {
                  return Center(child: Text("empty_data".tr, style: TextStyle(color: AppColors().black_font_color),));
                }
                return ListView.separated(
                  itemCount: savedLocations.length + 1, // +1 for the "Add new" tile
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index < savedLocations.length) {
                      final loc = savedLocations[index];
                      final isSelected =
                          loc.displayName == currentLocationName.value || loc.isCurrent;
                      return ListTile(
                        leading: Icon(Icons.place, color: isSelected ? Colors.green : null),
                        title: Text(loc.displayName, style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: AppColors().black_font_color,
                        ),),
                        subtitle: Text("${loc.upazila.isNotEmpty ? '${loc.upazila}, ' : ''}${loc.district}", style: TextStyle(color: AppColors().grey_font_color),),
                        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                        onTap: () async {
                          await selectSavedLocation(loc);
                        },
                        onLongPress: () async {
                          // optional: delete on long press (ask for confirmation)
                          if (loc.isCurrent) {
                            Get.snackbar("Cannot delete".tr,
                                "Current location cannot be deleted".tr);
                          } else {
                            final confirmed = await Get.defaultDialog<bool>(
                              title: "delete".tr,
                              middleText: '${"delete_hint".tr}"${loc.displayName}"',
                              textConfirm: "delete".tr,
                              textCancel: "cancel".tr,
                              onConfirm: () {
                                Get.back(result: true);
                              },
                              onCancel: () {
                                Get.back(result: false);
                              },
                            );
                            if (confirmed == true) {
                              await userService.deleteSavedLocation(
                                  loc.displayName);
                              await loadSavedLocations();
                            }
                          }
                        },
                      );
                    } else {
                      // Add new location tile
                      return ListTile(
                        leading: Icon(Icons.add_location_alt_outlined, color: AppColors().app_primary),
                        title: Text("add_location".tr, style: TextStyle(color: AppColors().app_primary),),
                        onTap: () async {
                          Get.back(); // close bottom sheet, then open map picker
                          await openAddLocationFlow();
                        },
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }


  /// When user taps a saved location in the selector
  Future<void> selectSavedLocation(SavedLocation loc) async {
    try {
      // set in shared prefs (this will also update the saved-locations list internally in service)
      final ok = await userService.setCurrentLocationByName(loc.displayName);
      if (ok) {
        // update controller's local fields and refresh weather
        await getSharedPrefData();
        await loadSavedLocations();
      } else {
        Get.snackbar("Error", "Unable to set current location".tr);
      }
      Get.back(); // close bottom sheet
    } catch (e) {
      debugPrint("Error selecting saved location: $e");
      Get.snackbar("Error", "Could not select location".tr);
    }
  }

  /// Flow: open map picker -> ask for name -> save location -> set as current -> refresh dashboard
  Future<void> openAddLocationFlow() async {
    try {
      // Open the upazila list page and await Data result
      final selected = await Get.to<Data?>(() => SelectLocationPage());
      if (selected == null) return;

      // Ask user for a custom display name (optional)
      final name = await _showLocationNameDialog();
      if (name == null || name.trim().isEmpty) {
        Get.snackbar("canceled".tr, "canceled_hint".tr);
        return;
      }

      final fetched = await userService.fetchLocationDetailsFromApi(
        lat: double.parse(selected.lat?.toStringAsFixed(5) ?? ""),
        lon: double.parse(selected.lng?.toStringAsFixed(5) ?? ""),
        displayNameFallback: name,
        setAsCurrent: true,
      );

      // Save the location details directly (since we already have them)
      if (fetched != null) {
        await userService.saveCustomLocation(
          lat: fetched.lat,
          lon: fetched.lon,
          apiId: fetched.id,
          apiName: fetched.apiName,
          displayName: fetched.displayName,
          upazila: fetched.upazila,
          district: fetched.district,
          setAsCurrent: true,
        );
      } else {
        // fallback: save with minimal info
        await userService.saveCustomLocation(
          lat: selected.lat?.toStringAsFixed(5) ?? "",
          lon: selected.lng?.toStringAsFixed(5) ?? "",
          apiId: '',
          apiName: name,
          displayName: name,
          upazila: '',
          district: '',
          setAsCurrent: true,
        );
      }

      await loadSavedLocations();
      await getSharedPrefData();
      Get.snackbar("success_title".tr, "success_msg".tr);
    } catch (e) {
      debugPrint("Error adding new location: $e");
      Get.snackbar("Error", "Failed to add location");
    }
  }

  /// Dialog to collect user-given name for picked location
  Future<String?> _showLocationNameDialog() async {
    final textController = TextEditingController();
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text("location_label".tr),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: "location_hint".tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: textController.text.trim()),
            child: Text("save_btn".tr),
          ),
        ],
      ),
    );
    return result;
  }

  /// This function is called by the RefreshIndicator in the UI
  Future<void> onRefresh() async {
    print("🔄 Pull to refresh triggered");

    // 1. Reload configuration (in case section order changed externally)
    await loadSectionOrder();
    await loadVisibilitySettings();

    await fetchNotifications();

    // 2. Reload saved locations (to keep the drawer list in sync)
    await loadSavedLocations();

    // 3. The most important part: Reload location data & Fetch Forecast
    // This method gets the lat/lon and calls getForecast() internally
    await getSharedPrefData();

    // 4. Reload survey questions (optional, but good practice)
    await loadQuestions();

    print("✅ Refresh complete");
  }
}
