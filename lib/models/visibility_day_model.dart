import 'package:flutter/cupertino.dart';

class VisibilityDay {
  final String date;
  final String day;
  final IconData icon;
  final List<double> brown;

  VisibilityDay({
    required this.date,
    required this.day,
    required this.icon,
    required this.brown,
  });

  // Example factory for parsing from API response
  factory VisibilityDay.fromJson(Map<String, dynamic> json, IconData icon) {
    return VisibilityDay(
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
