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

  static const String _storageKey = 'sectionOrder';

  @override
  void onInit() {
    super.onInit();
    loadSectionOrder();
  }

  /// This method is called when the user reorders the sections in the dashboard.
  void updateSectionOrder(List<HomeSection> newOrder) async {
    sectionOrder.value = newOrder;
    await saveSectionOrder();
  }

  Future<void> saveSectionOrder() async {
    final prefs = await SharedPreferences.getInstance();
    ///Convert a list of enum values to a list of strings for sharedPreference storage, because sharedPreference
    ///can only store strings.
    ///🚀TIPS: e.name is the string of the enum value.
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

  ///Converts a string (e.g., "sunMoon") back to the corresponding enum value.
  ///Uses firstWhere to match the name of the enum value.
  HomeSection _stringToHomeSection(String name) {
    return HomeSection.values.firstWhere((e) => e.name == name, orElse: () => HomeSection.weather_Forecast);
  }
}
