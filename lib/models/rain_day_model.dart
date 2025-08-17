import 'package:flutter/cupertino.dart';

class RainDay {
  final String date;
  final String day;
  final IconData icon;
  final List<double> brown;
  final List<double> green;

  RainDay({
    required this.date,
    required this.day,
    required this.icon,
    required this.brown,
    required this.green,
  });

  // Example factory for parsing from API response
  factory RainDay.fromJson(Map<String, dynamic> json, IconData icon) {
    return RainDay(
      date: json['date'],
      day: json['day'],
      icon: icon,
      brown: List<double>.from(json['brown'].map((x) => x.toDouble())),
      green: List<double>.from(json['green'].map((x) => x.toDouble())),
    );
  }

  // toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'icon': icon.codePoint, // Store icon code point
      'brown': brown,
      'green': green,
    };
  }

}
