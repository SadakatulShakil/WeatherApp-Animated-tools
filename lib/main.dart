import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:package_connector/controllers/forecast_controller.dart';
import 'package:package_connector/view/screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ForecastController());
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
      home:  WeatherHomePage(),
    );
  }
}
