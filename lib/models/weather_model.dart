import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';
class HourlyWeather {
  final String time;
  final IconData icon;
  final double temp;
  final int rainChance;
  final int index;

  HourlyWeather(this.time, this.icon, this.temp, this.rainChance, this.index);
}