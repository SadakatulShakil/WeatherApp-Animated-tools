class ForecastItem {
  final String date;
  final String day;
  final double minTemp;
  final double maxTemp;
  final String icon2DUrl; // new
  final String icon3DUrl; // new

  ForecastItem({
    required this.date,
    required this.day,
    required this.minTemp,
    required this.maxTemp,
    required this.icon2DUrl,
    required this.icon3DUrl,
  });
}
