class ForecastItem {
  final String date;
  final String day;
  final double minTemp;
  final double maxTemp;
  final String iconKey; // new

  ForecastItem({
    required this.date,
    required this.day,
    required this.minTemp,
    required this.maxTemp,
    required this.iconKey,
  });
}
