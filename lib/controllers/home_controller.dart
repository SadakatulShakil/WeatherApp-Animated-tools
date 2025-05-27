import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomeSection {
  weather_Forecast,
  weekly_Forecast,
  wind_Pressure,
  other_Info,
  sun_Moon,
  air_Quality,
}

class HomeController extends GetxController {
  var sectionOrder = <HomeSection>[].obs;
  var sectionVisibility = <HomeSection, bool>{}.obs;

  static const String _storageKey = 'sectionOrder';
  static const String _storageKeyVisibility = 'sectionVisibility';

  @override
  void onInit() {
    super.onInit();
    loadSectionOrder();
    loadVisibilitySettings();
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
}
