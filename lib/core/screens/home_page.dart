import 'package:bmd_weather_app/core/screens/notification_page.dart';
import 'package:bmd_weather_app/core/widgets/others/activity_indicator_widget.dart';
import 'package:bmd_weather_app/core/widgets/others/prayer_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:marquee/marquee.dart';

import '../../controllers/forecast_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/network_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../services/api_urls.dart';
import '../../utills/app_color.dart';
import '../../utills/app_drawer.dart';
import '../widgets/air_widget/air_quality_widget.dart';
import '../widgets/others/base_weather_card.dart';
import '../widgets/forecast_widget/weather_forecast.dart';
import '../widgets/forecast_widget/weekly_forecast_widget.dart';
import '../widgets/other_info_widget/other_info_card.dart';
import '../widgets/sun_and_moon_widget/sun_and_moon_widget.dart';
import '../widgets/others/survey_widget.dart';
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
  final internetController = Get.put(NetworkController(), permanent: true);
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

    return Obx(() {
      if (!controller.isLoaded.value) {
        return Center(child: lottie.Lottie.asset('assets/json/loading_anim.json', width: 80.w, height: 80.h),);
      }

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // makes status bar transparent
          statusBarIconBrightness: themeController.themeMode.value == ThemeMode.light
              ? Brightness.dark
              : Brightness.light, // or Brightness.light depending on text color
        ),
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: AppDrawer(),
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.onRefresh();
                    },
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
                          case HomeSection.activity_Indicator:
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ActivityIndicatorWidget(),
                            );
                          case HomeSection.prayer_Time:
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: PrayerTimeWidget(),
                            );
                        }
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Widget _buildFixedHeader(bool isNight) {
  //   return Stack(
  //     children: [
  //       // Background image
  //       Container(
  //         height: 280,
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: isNight
  //                 ? const AssetImage('assets/night.jpg')
  //                 : const AssetImage('assets/day.jpg'),
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //       // Gradient overlay
  //       Container(
  //         height: 300,
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: themeController.themeMode.value == ThemeMode.light
  //                 ?[Colors.black26, Colors.grey.shade300]
  //                 :[Colors.blue.withValues(alpha: 0.4), Color(0xFF165ABC)]
  //             ,
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //           ),
  //         ),
  //       ),
  //       // Location and time
  //       Align(
  //         alignment: Alignment.topRight,
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
  //           child: IconButton(
  //             icon: SvgPicture.asset(
  //               'assets/svg/menu_icon.svg',
  //               width: 40,
  //               height: 40,
  //             ),
  //             onPressed: () {
  //               _scaffoldKey.currentState!.openEndDrawer();
  //             },
  //           ),
  //         ),
  //       ),
  //       // Temperature and weather info
  //       Positioned(
  //         left: 0,
  //         right: 0,
  //         bottom: 5,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             ///------- Added Logic Here ------//
  //             Obx(() {
  //               print('check_state_dashboard: ${internetController.networkState.value}');
  //               switch (internetController.networkState.value) {
  //                 case NetworkState.loading:
  //                   return SizedBox(
  //                     height: 220.h,
  //                     child: Center(
  //                       child: Text(
  //                         'data_load_indicator'.tr,
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 16.sp,
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 case NetworkState.online:
  //                   return _buildWeatherCard();
  //                 case NetworkState.offline:
  //                   return _buildWeatherCardDemo();
  //               }
  //             }),
  //             ///-------add here ------//
  //             SizedBox(height: 12),
  //             Container(
  //               height: 45,
  //               color: Colors.orange,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   lottie.Lottie.asset(
  //                     'assets/json/alert.json',
  //                     width: 30,
  //                     height: 30,
  //                     repeat: true,
  //                   ),
  //                   SizedBox(width: 8.0,),
  //                   Text('২ ঘন্টার মধ্যে ঘূর্ণিঝড়ের সম্ভাবনা রয়েছে',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 15,
  //                       )),
  //                   lottie.Lottie.asset(
  //                     'assets/json/arrow_forward.json',
  //                     width: 40,
  //                     height: 40,
  //                     repeat: true,
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFixedHeader(bool isNight) {
    // 1. Get the device's top safe area (notch height)
    final double topPadding = MediaQuery.of(context).padding.top;

    final double baseImageHeight = 280.0.h;
    final double baseGradientHeight = 300.0.h;

    return Stack(
      children: [
        Container(
          height: baseImageHeight + topPadding,
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
          height: baseGradientHeight + topPadding,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeController.themeMode.value == ThemeMode.light
                  ? [Colors.black26, Colors.grey.shade300]
                  : [Colors.blue.withValues(alpha: 0.4), Color(0xFF165ABC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Location and time (Menu Icon)
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: topPadding, left: 8.w, right: 8.w),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/svg/menu_icon.svg',
                width: 40,
                height: 40,
              ),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
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
              ///------- Added Logic Here ------//
              Obx(() {
                print('check_state_dashboard: ${internetController.networkState.value}');
                switch (internetController.networkState.value) {
                  case NetworkState.loading:
                    return SizedBox(
                      height: 220.h,
                      child: Center(
                        child: Text(
                          'data_load_indicator'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    );
                  case NetworkState.online:
                    return _buildWeatherCard();
                  case NetworkState.offline:
                    return _buildWeatherCardDemo();
                }
              }),
              ///-------Marquee add here ------//
              SizedBox(height: 12),
              controller.dashboardAlertMessage.value.isEmpty
                  ? Container(
                height: 50.h,
                color: AppColors().app_alert_mild,
                child: Marquee(
                  text: 'empty_marque'.tr,
                  style: GoogleFonts.notoSansBengali(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 20.0.w,
                  velocity: 100.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 5.0.w,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              )
                  : GestureDetector(
                      onTap: () {
                        Get.to(NotificationPage(), transition: Transition.rightToLeft);
                      },
                    child: Container(
                      height: 50.h,
                      color: AppColors().app_alert_severe,
                      child: Marquee(
                    text: controller.dashboardAlertMessage.value,
                    style: GoogleFonts.notoSansBengali(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 20.0.w,
                    velocity: 100.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 5.0.w,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                                    ),
                                  ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCardDemo() {
    final isBangla = Get.locale?.languageCode == 'bn';
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 12.h),
      width: double.infinity,
      height: 200.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 15.h),
          SizedBox(height: 12.h),
          Column(
            children: [
              Text(isBangla?'🚫 ইন্টারনেট নাই':'🚫 No Internet',
                style: GoogleFonts.notoSansBengali(
                  fontWeight: FontWeight.w400,
                  fontSize: 25.sp,
                  letterSpacing: 1.0.sp,
                  color: Colors.white,
                ),
              ),
              Text(isBangla?'   ইন্টারনেট সংযোগ দিন':'Please Connect to Internet',
                style: GoogleFonts.notoSansBengali(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  letterSpacing: 1.0.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Obx(() {
      print('checkBool: ${controller.isForecastFetched.value}');
      if (!controller.isForecastFetched.value) {
        return Center(
          child: SizedBox(
            height: 200.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lottie.Lottie.asset(
                  'assets/json/server_issue.json',
                  height: 100.h,
                ),
                Text(
                  'server_maintenance_msg'.tr,
                  style: TextStyle(
                    color: AppColors().app_primary_bg,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final forecast = controller.forecast.value;
      if (forecast == null || forecast.result?.current == null) {
        return SizedBox(
          height: 200.h,
          child: Center(
            child: Text(
              'data_load_indicator'.tr,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        );
      }

      final current = controller.forecast.value?.result?.current;

      print('checkCurrentTemp: ${current?.temp?.valAvg}');
      return BaseWeatherCard(
        //iconUrl: "https://bamisapp.bdservers.site/assets/weather_icons/ic_sunny.png",
        location: controller.currentLocationName.value,
        date: "${current?.weekday}, ${current?.date}",
        temp: current?.temp?.valAvg ?? '',
        temp_unit: current?.tempUnit ?? '',
        tempMax:
        "${current?.temp?.valMax ?? ''}${current?.tempUnit ?? ''}",
        tempMin:
        "${current?.temp?.valMin ?? ''}${current?.tempUnit ?? ''}",
        rain: current?.rf?.valAvg ?? '',
        rain_unit: current?.rfUnit ?? '',
        feels_like:
        "${'feels_like'.tr} ${current?.temp?.valMax ?? ''}${current?.tempUnit ?? ''}",
        type: current?.type ?? 'N/A',
        humidity:
        "${current?.rh?.valAvg ?? ''} ${current?.rhUnit ?? ''}",
        wind:
        "${current?.windspd?.valAvg ?? ''}${current?.windspdUnit ?? ''}",
        loading: controller.isForecastLoading.value,
        controller: controller,
        onLocationTap: controller.openLocationSelector,
      );
    });
  }

}