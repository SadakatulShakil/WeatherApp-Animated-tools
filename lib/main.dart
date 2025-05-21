import 'package:bmd_weather_app/view/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/forecast_controller.dart';
import 'controllers/home_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ForecastController());
  Get.put(HomeController());
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather UI',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: WeatherHomePage(),
      //HomePage(),
    );
  }
}
