import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:package_connector/utills/app_drawer.dart';
import 'package:package_connector/view/widgets/other_info_card.dart';
import 'package:package_connector/view/widgets/pressure_meter.dart';
import 'package:package_connector/view/widgets/air_quality_animation.dart';
import 'package:package_connector/view/widgets/sunrise_arc_widget.dart';
import 'package:package_connector/view/widgets/sunset_arc_widget.dart';
import 'package:package_connector/view/widgets/weather_forecast.dart';
import 'package:package_connector/view/screens/xustom_paint_weather_data.dart';
import 'package:package_connector/view/widgets/weekly_forecast_widget.dart';
import 'package:package_connector/view/widgets/wind_meter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/forecast_controller.dart';
import '../widgets/air_quality_widget.dart';
import '../widgets/sun_and_moon_widget.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ForecastController controller = Get.put(ForecastController());

  // Dummy weather data
  double windSpeed = 16.8;
  double pressure = 1002.0;
  TimeOfDay sunrise = const TimeOfDay(hour: 5, minute: 42);
  TimeOfDay sunset = const TimeOfDay(hour: 18, minute: 25);

  final List<Map<String, dynamic>> forecastData = [
    {
      "date": "03/25",
      "day": "Today",
      "min": 32,
      "max": 38,
      "icon": Icons.wb_sunny,
    },
    {
      "date": "04/25",
      "day": "Friday",
      "min": 30,
      "max": 43,
      "icon": Icons.wb_sunny,
    },
    {
      "date": "05/25",
      "day": "Saturday",
      "min": 30,
      "max": 36,
      "icon": Icons.wb_sunny,
    },
    {
      "date": "06/25",
      "day": "Sunday",
      "min": 28,
      "max": 38,
      "icon": Icons.wb_sunny,
    },
    {
      "date": "07/25",
      "day": "Monday",
      "min": 30,
      "max": 44,
      "icon": Icons.wb_sunny,
    },
    {
      "date": "08/25",
      "day": "Thursday",
      "min": 32,
      "max": 43,
      "icon": Icons.wb_sunny,
    },
    {
      "date": "09/25",
      "day": "Wednesday",
      "min": 28,
      "max": 38,
      "icon": Icons.wb_sunny,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final isNight = now.hour < 6 || now.hour > 18;
    print('checkDayNight: ${now.hour}');
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue.shade700,
      body: ListView(
        controller: _scrollController,
        children: [
          ///Weather day/night images
          Stack(
            children: [
              // Background image
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        isNight
                            ? const AssetImage('assets/night.jpg')
                            : const AssetImage('assets/day.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient overlay
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.withOpacity(.4)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Location and time
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Mirpur DOHS, Dhaka',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Fri 5.00 PM',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.storage_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Show the drawer
                        _scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                  ],
                ),
              ),

              // Temperature and weather info
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weather condition
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "Fully Clear",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Temperature
                    Text(
                      "32°C",
                      style: TextStyle(
                        fontSize: 72,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Weather details row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Feels like 36°C",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            height: 16,
                            width: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          Text(
                            "+41°C -29°C",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            height: 16,
                            width: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          Text(
                            "31%",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
            child: WeeklyForecastView(),
          ),
          const SizedBox(height: 10),

          /// Wind Speed compass and Pressure gauge
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.only(left: 4, right: 4),
              mainAxisSpacing: 12,
              childAspectRatio: 0.70,
              // <<< Important! Adjust card height!
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.air, color: Colors.white, size: 22),
                          Expanded(
                            child: Text(
                              'Wind',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Expanded(
                        child: WindCompass(
                          windSpeed: windSpeed,
                          windDirection: 0, // North
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.compress, color: Colors.white, size: 22),
                          Expanded(
                            child: Text(
                              'Pressure',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Expanded(child: PressureMeter(pressureValue: pressure)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///OtherInfo(Precipitation, Humidity, UV index, Visibility)
          Padding(padding: const EdgeInsets.all(10.0), child: OtherInfoCards()),
          const SizedBox(height: 10),

          ///Sun & Moon phase
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8,
              bottom: 8,
            ),
            child: SunAndMoonWidget(),
          ),

          /// Air quality indicator
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8,
              bottom: 8,
            ),
            child: AirQualityWidget(currentValue: 42.0),
          ),
        ],
      ),
    );
  }

  // Widget _weeklyForecastList() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16),
  //       gradient: LinearGradient(
  //         colors: [Colors.blue.shade500, Colors.blue.shade500],
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             "Forecast, Next 7 days",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         SingleChildScrollView(
  //           child: Obx(
  //             () => Column(
  //               children: List.generate(controller.forecastList.length, (index) {
  //                 final item = controller.forecastList[index];
  //                 final iconUrl = controller.getIconUrl(item.iconKey);
  //
  //                 return Column(
  //                   children: [
  //                     SizedBox(height: 16,),
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: Column(
  //                             children: [
  //                               Text(
  //                                 '${item.day}',
  //                                 style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 '${item.date}',
  //                                 style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: Image.asset(iconUrl, width: 25, height: 25),
  //                         ),
  //                         Text(
  //                           '${item.minTemp}°C',
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 10),
  //                             child: Stack(
  //                               children: [
  //                                 Container(
  //                                   height: 8,
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(8),
  //                                     color: Colors.white.withOpacity(0.2),
  //                                   ),
  //                                 ),
  //                                 FractionallySizedBox(
  //                                   widthFactor: (item.maxTemp - item.minTemp) / 15.0,
  //                                   child: Container(
  //                                     height: 8,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(8),
  //                                       gradient: const LinearGradient(
  //                                         colors: [
  //                                           Colors.orange,
  //                                           Colors.deepOrange,
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: Text(
  //                             '${item.maxTemp}°C',
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 14,
  //                             ),
  //                           ),
  //                         ),
  //                         Icon(
  //                           Icons.arrow_forward_ios,
  //                           color: Colors.white,
  //                           size: 18,
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: 10,),
  //                   ],
  //                 );
  //               }),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
