import 'package:flutter/cupertino.dart';

class HumidityDay {
  final String date;
  final String day;
  final IconData icon;
  final List<double> brown;

  HumidityDay({
    required this.date,
    required this.day,
    required this.icon,
    required this.brown,
  });

  // Example factory for parsing from API response
  factory HumidityDay.fromJson(Map<String, dynamic> json, IconData icon) {
    return HumidityDay(
      date: json['date'],
      day: json['day'],
      icon: icon,
      brown: List<double>.from(json['brown'].map((x) => x.toDouble())),
    );
  }

  // toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'icon': icon.codePoint, // Store icon code point
      'brown': brown,
    };
  }

}
