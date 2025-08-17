import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;

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
          child: Column(
            children: [
              /// Fixed Header (Top section)
              _buildFixedHeader(isNight),

              /// Scrollable Dynamic widgets
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: controller.sectionOrder
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
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildFixedHeader(bool isNight) {
    return Stack(
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
          height: 330,
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
          padding: const EdgeInsets.only(top: 45, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'মিরপুর ডিওএইচএস, ঢাকা',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 24,
                        ),
                      ],
                    ),
                    Text(
                      'Fri 5.00 PM',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svg/menu_icon.svg',
                  width: 40,
                  height: 40,
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
          left: 0,
          right: 0,
          bottom: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Container(
                          padding:  EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.blue.shade900.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "সম্পূর্ণ পরিষ্কার",
                            style: TextStyle(fontSize: 14,
                                letterSpacing: 0.5,
                                color: themeController.themeMode.value == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '৩২°',
                                style: TextStyle(
                                  fontFamily: 'NotoSansBengali',
                                  fontSize: 62,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'সে',
                                style: TextStyle(
                                  fontFamily: 'NotoSansBengali',
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(foreCast_controller.getIconUrl('sun_cloud'),
                            width: 64, height: 64),
                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF00CEB5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "আমার পর্যবেক্ষণ",
                                style: TextStyle(fontSize: 14,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "মনে হচ্ছে ৩৬° সে",
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
                        "+৪১°সে - ২৯°সে",
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
                      Row(
                        children: [
                          Icon(
                            Icons.cloudy_snowing,
                            size: 16,
                            color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "৩১%",
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
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    lottie.Lottie.asset(
                      'assets/json/alert.json',
                      width: 30,
                      height: 30,
                      repeat: true,
                    ),
                    SizedBox(width: 8.0,),
                    Text('২ ঘন্টার মধ্যে ঘূর্ণিঝড়ের সম্ভাবনা রয়েছে',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                    lottie.Lottie.asset(
                      'assets/json/arrow_forward.json',
                      width: 40,
                      height: 40,
                      repeat: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}