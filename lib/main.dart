import 'package:bmd_weather_app/core/screens/splash_screen.dart';
import 'package:bmd_weather_app/services/LocalizationString.dart';
import 'package:bmd_weather_app/services/user_pref_service.dart';
import 'package:bmd_weather_app/utills/firebase_option.dart';
import 'package:bmd_weather_app/utills/theme.dart';
import 'package:bmd_weather_app/water_watch_controller/dashboard/DashboardController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controllers/forecast_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/screens/home_page.dart';
import 'database_helper/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("DEBUG: 0. WidgetsFlutterBinding ensured.");

  // --- Localization ---
  try {
    await initializeDateFormatting('bn_BD', null);
    print("DEBUG: 1. Date Formatting Loaded.");
  } catch (e) {
    print("🔥 Date Formatting Error: $e");
  }

  // --- Firebase Init ---
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('DEBUG: 2. Firebase Initialized Successfully.');
  } catch (e, stack) {
    print('🔥 FATAL FIREBASE ERROR: $e');
    print(stack);
  }

  await UserPrefService().init();
  print('DEBUG: 3. User Preferences Initialized.');

  try {
    final dbService = await DBService().init();
    Get.put(dbService, permanent: true);
    print('DEBUG: 4. DB Service Init Complete.');
  } catch (e, stack) {
    print('🔥 DATABASE INIT ERROR: $e');
    print(stack);
  }
  Get.put(SettingsController());
  final savedLang = UserPrefService().appLanguage;
  print('DEBUG: 5. Saved Language: $savedLang');

  // --- Put Controllers ---
  Get.put(ThemeController());
  Get.put(WaterWatchDashboardController());
  Get.put(ForecastController());
  Get.put(HomeController(), permanent: true);

  // --- System UI Settings ---
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(WeatherApp(savedLang));
}

class WeatherApp extends StatelessWidget {
  final themeController = Get.find<ThemeController>();
  final String savedLang;
  WeatherApp(this.savedLang, {super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather App',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeController.themeMode.value,
          home: SplashScreen(),
          translations: LocalizationString(),
          locale: Locale(savedLang),
        );
      },
    );
  }
}
