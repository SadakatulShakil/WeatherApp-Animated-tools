import 'package:bmd_weather_app/utills/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controllers/forecast_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ForecastController());
  Get.put(HomeController());
  Get.put(ThemeController());
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  final themeController = Get.find<ThemeController>();
   WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // makes status bar transparent
      statusBarIconBrightness: Brightness.dark, // or Brightness.light depending on text color
    ));
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
