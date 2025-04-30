import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../../models/hourly_weather_model.dart';

class WeatherForecastChart extends StatelessWidget {


  final List<HourlyWeatherModel> demoData = [
    HourlyWeatherModel("00:00", WeatherIcons.night_clear, 25.0, 10, 0),
    HourlyWeatherModel("03:00", WeatherIcons.cloud, 30.0, 20, 1),
    HourlyWeatherModel("06:00", WeatherIcons.rain, 38.0, 70, 2),
    HourlyWeatherModel("09:00", WeatherIcons.day_sunny, 24.0, 15, 3),
    HourlyWeatherModel("12:00", WeatherIcons.day_sunny, 32.0, 5, 4),
    HourlyWeatherModel("15:00", WeatherIcons.cloud, 30.0, 25, 5),
    HourlyWeatherModel("18:00", WeatherIcons.rain, 38.5, 60, 6),
    HourlyWeatherModel("21:00", WeatherIcons.night_clear, 25.0, 10, 7),
    HourlyWeatherModel("00:00", WeatherIcons.night_clear, 32.5, 12, 8),
    HourlyWeatherModel("03:00", WeatherIcons.cloud, 36.0, 30, 9),
    HourlyWeatherModel("06:00", WeatherIcons.rain, 38.5, 80, 10),
    HourlyWeatherModel("09:00", WeatherIcons.day_sunny, 25.0, 20, 11),
    HourlyWeatherModel("12:00", WeatherIcons.day_sunny, 28.0, 10, 12),
    HourlyWeatherModel("15:00", WeatherIcons.cloud, 35.0, 40, 13),
    HourlyWeatherModel("18:00", WeatherIcons.rain, 32.5, 55, 14),
    HourlyWeatherModel("21:00", WeatherIcons.night_clear, 30.0, 18, 15),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.blue.shade500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Forecast, Next 72 hours",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          // Weather forecast chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: demoData.length * 80,
                  child: Stack(
                    children: [
                      LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          minX: -.4,
                          maxX: demoData.length.toDouble() - .5,
                          minY: 12,
                          maxY: 50,
                          lineBarsData: [
                            LineChartBarData(
                              spots:
                              demoData
                                  .map(
                                    (e) => FlSpot(
                                  e.index.toDouble(),
                                  e.temp,
                                ),
                              )
                                  .toList(),
                              color: Colors.transparent,
                              isCurved: true,
                              belowBarData: BarAreaData(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade200,
                                    Colors.blue.shade500,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                show: true,
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                    FlDotCirclePainter(
                                      radius: 2,
                                      color: Colors.transparent,
                                      strokeColor: Colors.greenAccent,
                                      // Your desired dot color
                                      strokeWidth: 2.5,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:
                          demoData.map((hour) {
                            return Expanded(
                              child: Column(
                                children: [
                                  // Time and icon at top
                                  Text(
                                    hour.time,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Icon(
                                    hour.icon,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Spacer(),

                                  // Temperature just below dot
                                  Text(
                                    '${hour.temp.toInt()}°C',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),

                                  SizedBox(height: 4),
                                  // Rain chance
                                  Text(
                                    '${hour.rainChance}% ',
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),

                                  // Wind at the bottom
                                  SizedBox(height: 4),
                                  Text(
                                    '${(hour.temp * 0.5).toStringAsFixed(1)} km/h',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
