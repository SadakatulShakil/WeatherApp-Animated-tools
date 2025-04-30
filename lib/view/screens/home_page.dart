import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_connector/utills/app_drawer.dart';
import 'package:package_connector/view/widgets/other_info_widget/other_info_card.dart';
import 'package:package_connector/view/widgets/forecast_widget/weather_forecast.dart';
import 'package:package_connector/view/widgets/forecast_widget/weekly_forecast_widget.dart';

import '../../controllers/home_controller.dart';
import '../widgets/air_widget/air_quality_widget.dart';
import '../widgets/sun_and_moon_widget/sun_and_moon_widget.dart';
import '../widgets/wind_and_pressure_widget/wind_pressure_cards.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController controller = Get.put(HomeController());

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
      key: _scaffoldKey,
      drawer: AppDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue.shade700,
      body: Column(
        children: [
          /// Fixed top section (weather image stack)
          Stack(
            children: [
              // Background image
              Container(
                height: 280,
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
                height: 280,
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
                padding: const EdgeInsets.only(top: 35, left: 16, right: 16),
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

          /// Dynamic sections based on saved order
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.sectionOrder.length,
                itemBuilder: (context, index) {
                  final section = controller.sectionOrder[index];

                  switch (section) {
                    case HomeSection.weatherForecast:
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: WeatherForecastChart(),
                      );
                    case HomeSection.weeklyForecast:
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: WeeklyForecastView(),
                      );
                    case HomeSection.windPressure:
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: WindAndPressureCards(),
                      );
                    case HomeSection.otherInfo:
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: OtherInfoCards(),
                      );
                    case HomeSection.sunMoon:
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SunAndMoonWidget(),
                      );
                    case HomeSection.airQuality:
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AirQualityWidget(currentValue: 42.0),
                      );
                    default:
                      return SizedBox.shrink();
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
