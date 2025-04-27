import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_connector/view/screens/home_page.dart';
import 'package:package_connector/view/widgets/weather_forecast.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math' as math;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather UI',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:  WeatherHomePage(),
    );
  }
}
