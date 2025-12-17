import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';
class WeeklyForecastItem {
  final String date;
  final String day;
  final dynamic minTemp;
  final dynamic maxTemp;
  final String iconKey; // new

  WeeklyForecastItem(
     this.date,
     this.day,
     this.minTemp,
     this.maxTemp,
     this.iconKey,
  );
}
