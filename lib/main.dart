import 'package:bmd_weather_app/utills/theme.dart';
import 'package:bmd_weather_app/view/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/forecast_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ForecastController());
  Get.put(HomeController());
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
   WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather UI',
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: themeController.themeMode.value,
      home: WeatherHomePage(),
      //HomePage(),
    );
  }
}
