import 'package:get/get.dart';

import '../models/forecast_model.dart';

enum IconMode { twoD, threeD }

class ForecastController extends GetxController {
  var iconMode = IconMode.twoD.obs;
  var forecastList = <ForecastItem>[].obs;

  void switchIconMode(IconMode mode) {
    iconMode.value = mode;
    print('controller_check: ${iconMode.value}');
  }

  void updateForecastList(List<ForecastItem> data) {
    forecastList.value = data;
  }

// Add this constructor or method to initialize demo data
  @override
  void onInit() {
    super.onInit();
    forecastList.value = [
      ForecastItem(
        date: '2023-10-01',
        day: 'Monday',
        minTemp: 15.0,
        maxTemp: 25.0,
        icon2DUrl: 'assets/twoD/moon_cloud1.png',
        icon3DUrl: 'assets/threeD/moon_cloud.png',
      ),
      ForecastItem(
        date: '2023-10-02',
        day: 'Tuesday',
        minTemp: 16.0,
        maxTemp: 26.0,
        icon2DUrl: 'assets/twoD/moon_rain1.png',
        icon3DUrl: 'assets/threeD/moon_rain.png',
      ),
      ForecastItem(
        date: '2023-10-03',
        day: 'Wednesday',
        minTemp: 16.0,
        maxTemp: 26.0,
        icon2DUrl: 'assets/twoD/sun_cloud1.png',
        icon3DUrl: 'assets/threeD/moon_cloud.png',
      ),
      ForecastItem(
        date: '2023-10-04',
        day: 'Thursday',
        minTemp: 16.0,
        maxTemp: 26.0,
        icon2DUrl: 'assets/twoD/sun_rain1.png',
        icon3DUrl: 'assets/threeD/sun_rain.png',
      ),
      ForecastItem(
        date: '2023-10-05',
        day: 'Friday',
        minTemp: 16.0,
        maxTemp: 26.0,
        icon2DUrl: 'assets/twoD/tornado1.png',
        icon3DUrl: 'assets/threeD/tornado.png',
      ),
      // Add more demo items as needed
    ];
  }

}
