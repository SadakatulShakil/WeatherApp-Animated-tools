import 'package:flutter/material.dart';

// Point for the Chart
class ChartPoint {
  final double x; // Usually the Hour (0-23)
  final double y; // The Value (mm or %)
  ChartPoint(this.x, this.y);
}

// UI Model for the Daily List/Selector
class WeatherUiModel {
  final String dateRaw;
  final String dateDisplay;
  final String dayName;
  final List<ChartPoint> points;
  final double minVal;
  final double maxVal;
  final double avgVal;

  WeatherUiModel({
    required this.dateRaw,
    required this.dateDisplay,
    required this.dayName,
    required this.points,
    required this.minVal,
    required this.maxVal,
    required this.avgVal,
  });
}