import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_connector/view/widgets/other_info_card.dart';
import 'package:package_connector/view/widgets/pressure_meter.dart';
import 'package:package_connector/view/widgets/air_quality_animation.dart';
import 'package:package_connector/view/widgets/sunrise_arc_widget.dart';
import 'package:package_connector/view/widgets/sunset_arc_widget.dart';
import 'package:package_connector/view/widgets/weather_forecast.dart';
import 'package:package_connector/view/screens/xustom_paint_weather_data.dart';
import 'package:package_connector/view/widgets/wind_meter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/sun_and_moon_widget.dart';

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

  final List<Map<String, dynamic>> forecastData = [
    {"date": "03/25", "day": "Today", "min": 32, "max": 38, "icon": Icons.wb_sunny},
    {"date": "04/25", "day": "Friday", "min": 30, "max": 43, "icon": Icons.wb_sunny},
    {"date": "05/25", "day": "Saturday", "min": 30, "max": 36, "icon": Icons.wb_sunny},
    {"date": "06/25", "day": "Sunday", "min": 28, "max": 38, "icon": Icons.wb_sunny},
    {"date": "07/25", "day": "Monday", "min": 30, "max": 44, "icon": Icons.wb_sunny},
    {"date": "08/25", "day": "Thursday", "min": 32, "max": 43, "icon": Icons.wb_sunny},
    {"date": "09/25", "day": "Wednesday", "min": 28, "max": 38, "icon": Icons.wb_sunny},
  ];


  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final isNight = now.hour < 6 || now.hour > 18;
    print('checkDayNight: ${now.hour}');
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      appBar: AppBar(
        title: Column(
          children: [
             Text('Mirpur DOHS, Dhaka', style: TextStyle(color: Colors.white, fontSize: 18)),
             Text('Fri 5.00 PM', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        backgroundColor: isNight? Colors.blue.shade500.withOpacity(.01): Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_outlined, color: Colors.white,),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          ///Weather day/night images
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: isNight? AssetImage('assets/night.jpg'):AssetImage('assets/day.jpg'), // replace with your image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade500.withOpacity(.4), Colors.blue.withOpacity(.3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ), // Adjust opacity as needed
              ),
              Positioned(
                left: 20,
                bottom: 0,
                top: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue.shade900,
                      ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2, bottom: 2),
                          child: Text("Fully Clear", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                        )),
                    SizedBox(height: 4),
                    Text("32°C", style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold)),
                    ///problematic ROW. space between not work why?
                    Container(
                      width: MediaQuery.of(context).size.width * .9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Feels like: 32°C", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                          Text("Humidity: 45%", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                          Icon(Icons.sunny_snowing, color: Colors.white,)
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ///Weather forecast data
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: WeatherForecastChart(),
          ),
          const SizedBox(height: 10),
          ///Weekly weather data
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _weeklyForecastList(),
          ),
          const SizedBox(height: 10),
          /// Wind Speed compass and Pressure gauge
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                    color: Colors.blue.shade400,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.air, color: Colors.white, size: 18,),
                            Text('Wind', style: TextStyle(color: Colors.white, fontSize: 18)),
                            SizedBox(width: 40,),
                            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18,),
                          ],
                        ),
                        WindCompass(
                          windSpeed: windSpeed,
                          windDirection: 0, // North
                        ),

                      ],
                    )),
                Card(
                    color: Colors.blue.shade400,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.compress, color: Colors.white, size: 18,),
                            Text('Pressure', style: TextStyle(color: Colors.white, fontSize: 18)),
                            SizedBox(width: 20,),
                            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18,),
                          ],
                        ),
                        PressureMeter(pressureValue: pressure),
                      ],
                    )),
              ],
            ),
          ),
          ///OtherInfo(Precipitation, Humidity, UV index, Visibility)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: OtherInfoCards(),
          ),
          const SizedBox(height: 10),
          ///Sun & Moon phase
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8, bottom: 8),
            child: SunAndMoonWidget(),
          ),
          /// Air quality indicator
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AirQualityWidget(
              currentValue: 42.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklyForecastList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.blue.shade500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "পরবর্তী 7 দিনের পূর্বাভাস",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: forecastData.map((dayData) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                dayData['date'],
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                dayData['day'],
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Icon(dayData['icon'], color: Colors.yellowAccent)),
                        Text(
                          '${dayData['min']}°',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: (dayData['max'] - dayData['min']) / 15.0, // adjust max width range
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        colors: [Colors.orange, Colors.deepOrange],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${dayData['max']}°',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18,),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

