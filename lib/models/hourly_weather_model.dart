// models/hourly_weather_model.dart
class HourlyWeatherModel {
  final String time;
  final String iconKey;
  final double temp;
  final double rainAmount; // Changed from int rainChance to double
  final double windSpeed;
  final int index;

  HourlyWeatherModel({
    required this.time,
    required this.iconKey,
    required this.temp,
    required this.rainAmount,
    required this.windSpeed,
    required this.index,
  });
}