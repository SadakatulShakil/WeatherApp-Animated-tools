import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_connector/controllers/forecast_controller.dart';
import 'package:package_connector/view/screens/home_page.dart';
import 'package:package_connector/view/widgets/weekly_forecast_widget.dart';

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
