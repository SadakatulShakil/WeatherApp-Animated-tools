import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';
class HourlyWeatherModel {
  final String time;
  final IconData icon;
  final double temp;
  final int rainChance;
  final int index;

  HourlyWeatherModel(this.time, this.icon, this.temp, this.rainChance, this.index);
}