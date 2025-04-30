import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';
class HourlyWeatherModel {
  final String time;
  final String iconKey;
  final double temp;
  final int rainChance;
  final int index;

  HourlyWeatherModel(this.time, this.iconKey, this.temp, this.rainChance, this.index);
}