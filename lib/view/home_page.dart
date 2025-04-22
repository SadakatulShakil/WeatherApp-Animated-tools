import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_connector/view/pressure_meter.dart';
import 'package:package_connector/view/sun_path_animation.dart';
import 'package:package_connector/view/xustom_paint_weather_data.dart';
import 'package:package_connector/view/wind_meter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final ScrollController _scrollController = ScrollController();

  // Dummy weather data
  double windSpeed = 16.8;
  double pressure = 1002.0;
  TimeOfDay sunrise = const TimeOfDay(hour: 5, minute: 42);
  TimeOfDay sunset = const TimeOfDay(hour: 18, minute: 25);

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final isNight = now.hour < 6 || now.hour > 18;
    print('checkDayNight: ${now.hour}');
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              isNight ? 'assets/night.jpg' : 'assets/day.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.8), // Adjust opacity here
            ),
          ),

          // Optional opacity overlay (to darken/soften)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Adjust opacity here
            ),
          ),

          // Main content with SafeArea and ListView
          SafeArea(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Today\'s Weather',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDummyForecast(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: Colors.blue.shade300,
                        child: Column(
                          children: [
                            const Text('Wind Speed', style: TextStyle(color: Colors.white, fontSize: 18)),
                            WindCompass(
                              windSpeed: windSpeed,
                              windDirection: 0, // North
                            ),

                            //WindMeter(speed: 12.6, direction: 45, primaryColor: Colors.white, secondaryColor: Colors.white),
                          ],
                        )),
                    Card(
                        color: Colors.blue.shade300,
                        child: Column(
                      children: [
                        const Text('Pressure', style: TextStyle(color: Colors.white, fontSize: 18)),
                        PressureMeter(pressureValue: pressure),
                        //PressureMeter(pressure: 1007),
                      ],
                    )),
                  ],
                ),
                const SizedBox(height: 40),
                SunriseSunsetWidget(
                  sunrise: sunrise,
                  sunset: sunset,
                  currentTime: now,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDummyForecast() {
    return Column(
      children: List.generate(15, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${12 + index * 3}:00', style: const TextStyle(color: Colors.white)),
              const Icon(Icons.wb_sunny, color: Colors.yellow),
              Text('${30 + index}°C', style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      }),
    );
  }
}

