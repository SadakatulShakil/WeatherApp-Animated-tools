import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/forecast_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utills/app_drawer.dart';
import '../widgets/air_widget/air_quality_widget.dart';
import '../widgets/forecast_widget/weather_forecast.dart';
import '../widgets/forecast_widget/weekly_forecast_widget.dart';
import '../widgets/other_info_widget/other_info_card.dart';
import '../widgets/sun_and_moon_widget/sun_and_moon_widget.dart';
import '../widgets/wind_and_pressure_widget/wind_pressure_cards.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController controller = Get.put(HomeController());
  final ForecastController foreCast_controller = Get.put(ForecastController());
  final ThemeController themeController = Get.find<ThemeController>();
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
    return Obx(() => AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // makes status bar transparent
        statusBarIconBrightness: themeController.themeMode.value == ThemeMode.light
            ? Brightness.dark
            : Brightness.light, // or Brightness.light depending on text color
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeController.themeMode.value == ThemeMode.light
                  ? [Colors.grey.shade300, Colors.white]
                  : [Color(0xFF165ABC), Color(0xFF1B76AB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              /// Header (Top section fixed)
              Stack(
                children: [
                  // Background image
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: isNight
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
                        colors: themeController.themeMode.value == ThemeMode.light
                            ?[Colors.black26, Colors.grey.shade300]
                            :[Colors.blue.withValues(alpha: 0.4), Color(0xFF165ABC)]
                        ,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Location and time
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
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
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/svg/menu_icon.svg',
                            color: Colors.white,
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () {
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.blue.shade900.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Fully Clear",
                            style: TextStyle(fontSize: 14,
                                color: themeController.themeMode.value == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "32°C",
                              style: TextStyle(
                                fontSize: 72,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                height: 0.9,
                              ),
                            ),
                            Image.asset(foreCast_controller.getIconUrl('sun_cloud'), width: 80, height: 80),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Feels like 36°C",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.themeMode.value == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                height: 16,
                                width: 1,
                                color: themeController.themeMode.value == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              Text(
                                "+41°C -29°C",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.themeMode.value == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                height: 16,
                                width: 1,
                                color: themeController.themeMode.value == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              Text(
                                "31%",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.themeMode.value == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
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
              /// Dynamic widgets
              ...controller.sectionOrder
                  .where((section) => controller.sectionVisibility[section] ?? true)
                  .map((section) {
                switch (section) {
                  case HomeSection.weather_Forecast:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: WeatherForecastChart(),
                    );
                  case HomeSection.weekly_Forecast:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: WeeklyForecastView(),
                    );
                  case HomeSection.wind_Pressure:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: WindAndPressureCards(),
                    );
                  case HomeSection.other_Info:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: OtherInfoCards(),
                    );
                  case HomeSection.sun_Moon:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SunAndMoonWidget(),
                    );
                  case HomeSection.air_Quality:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AirQualityWidget(currentValue: 42.0),
                    );
                }
              }),
            ],
          ),
        ),
      ),
    ));
  }
}
