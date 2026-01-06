// models/hourly_weather_model.dart
class HourlyWeatherModel {
  final String time;
  final String iconKey;
  final double temp;
  final double rainAmount;
  final double humidity;
  final double windSpeed;
  final int index;

  HourlyWeatherModel({
    required this.time,
    required this.iconKey,
    required this.temp,
    required this.rainAmount,
    required this.humidity,
    required this.windSpeed,
    required this.index,
  });
}