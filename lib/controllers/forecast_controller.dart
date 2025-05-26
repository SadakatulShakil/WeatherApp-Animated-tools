import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weekly_forecast_model.dart';
import '../models/icon_model.dart';


class ForecastController extends GetxController {
  var iconMode = 'twoD'.obs; // This will hold the selected icon package name like "twoD", "threeD"
  var forecastList = <WeeklyForecastItem>[].obs;

  /// All icon packages (key = package name, value = list of icons)
  var iconPackages = <String, List<WeatherIcon>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadIconPreference();
    loadMockData(); /// Replace with real API in production
  }

  /// This method is called when the user selects a new icon mode.
  void switchIconMode(String mode) async {
    iconMode.value = mode;
    // iconMode.refresh();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('icon_mode', mode);
  }

  /// This method returns the icon URL based on the current icon mode and the icon key.
  String getIconUrl(String iconKey) {
    final currentIcons = iconPackages[iconMode.value] ?? [];
    return currentIcons.firstWhere(
          (i) => i.iconKey == iconKey,
      orElse: () => WeatherIcon(iconKey: '', iconUrl: ''),
    ).iconUrl;
  }

  /// This method loads the icon mode from shared preferences when the app starts.
  void loadIconPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('icon_mode') ?? 'twoD';
    iconMode.value = saved;
  }

  /// This method simulates loading data from an API.
  void loadMockData() {
    // Simulating API response structure
    iconPackages.assignAll({
      'twoD': [
        WeatherIcon(iconKey: 'moon_cloud', iconUrl: 'assets/twoD/moon_cloud1.png'),
        WeatherIcon(iconKey: 'moon_rain', iconUrl: 'assets/twoD/moon_rain1.png'),
        WeatherIcon(iconKey: 'sun_cloud', iconUrl: 'assets/twoD/sun_cloud1.png'),
        WeatherIcon(iconKey: 'sun_rain', iconUrl: 'assets/twoD/sun_rain1.png'),
        WeatherIcon(iconKey: 'tornado', iconUrl: 'assets/twoD/tornado1.png'),
      ],
      'threeD': [
        WeatherIcon(iconKey: 'moon_cloud', iconUrl: 'assets/threeD/moon_cloud.png'),
        WeatherIcon(iconKey: 'moon_rain', iconUrl: 'assets/threeD/moon_rain.png'),
        WeatherIcon(iconKey: 'sun_cloud', iconUrl: 'assets/threeD/sun_cloud.png'),
        WeatherIcon(iconKey: 'sun_rain', iconUrl: 'assets/threeD/sun_rain.png'),
        WeatherIcon(iconKey: 'tornado', iconUrl: 'assets/threeD/tornado.png'),
      ],
      /// Add more dynamically here like 'darkMode', 'lightMode', etc.
    });

    /// Mock data for forecast items
    forecastList.assignAll([
      WeeklyForecastItem(day: 'Mon', date: '05/22', minTemp: 15, maxTemp: 35, iconKey: 'moon_cloud'),
      WeeklyForecastItem(day: 'Tues', date: '05/23', minTemp: 16, maxTemp: 33, iconKey: 'moon_rain'),
      WeeklyForecastItem(day: 'Wed', date: '05/24', minTemp: 17, maxTemp: 34, iconKey: 'sun_cloud'),
      WeeklyForecastItem(day: 'Thurs', date: '05/25', minTemp: 18, maxTemp: 32, iconKey: 'sun_rain'),
      WeeklyForecastItem(day: 'Fri', date: '05/26', minTemp: 19, maxTemp: 31, iconKey: 'tornado'),
    ]);
  }
}
