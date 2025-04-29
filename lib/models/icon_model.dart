class WeatherIcon {
  final String iconKey;
  final String iconUrl;

  WeatherIcon({required this.iconKey, required this.iconUrl});

  factory WeatherIcon.fromJson(Map<String, dynamic> json) {
    return WeatherIcon(
      iconKey: json['iconKey'],
      iconUrl: json['iconUrl'],
    );
  }
}
