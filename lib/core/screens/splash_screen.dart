import 'dart:async';

import 'package:bmd_weather_app/core/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../services/firebase_service.dart';
import '../../services/location_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State with WidgetsBindingObserver {
  bool _initialized = false;
  bool _shouldNavigate = false;
  bool isWaitingForSettings = false; // flag to handle background/resume flow

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isWaitingForSettings) {
        print("DEBUG: App resumed after settings. Retrying location...");
        isWaitingForSettings = false;
        _initializeApp();
      }
    }
  }

  Future _initializeApp() async {
    if (_initialized || _shouldNavigate) return;

    try {
      print("DEBUG: Initializing services...");

      // Initialize Firebase notifications
      await FirebaseService().initNotifications();
      print("DEBUG: Firebase initialized");

      // Initialize location service
      await LocationService().getLocation(onSettingsOpened: () {
        isWaitingForSettings = true;
      });
      print("DEBUG: Location initialized and API called");

      // Mark initialized & navigate
      if (mounted) setState(() => _initialized = true);

      Timer(const Duration(milliseconds: 300), _navigateToNextScreen);
    } catch (e) {
      print("DEBUG: Initialization halted: $e");
      if (mounted) setState(() => _initialized = false);
    }

  }

  void _navigateToNextScreen() {
    if (_shouldNavigate) return;
    _shouldNavigate = true;

    Get.offAll(
          () => const WeatherHomePage(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 300),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/logo.png', height: 120.h),
            SizedBox(height: 16.h),
            Text(
              "Powered by RIMES",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 24.h),
            Lottie.asset('assets/json/loading_anim.json', width: 80.w, height: 80.h),
            SizedBox(height: 16.h),
            Text(
              _initialized ? "Ready! Launching App..." : "Initializing Services...",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}