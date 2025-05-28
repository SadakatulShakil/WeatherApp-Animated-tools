import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/theme_controller.dart';
import 'air_quality_animation.dart';

class AirQualityWidget extends StatefulWidget {

  final double currentValue;// Expected between 0-100
  const AirQualityWidget({
    super.key,
    required this.currentValue,
  });
  @override
  State<AirQualityWidget> createState() => _AirQualityWidgetState();
}

class _AirQualityWidgetState extends State<AirQualityWidget> {
  final ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: themeController.themeMode.value == ThemeMode.light
              ? [Colors.white, Colors.white]
              : [Color(0xFF3986DD), Color(0xFF3986DD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.wind_power,
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Air Quality',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.currentValue.toStringAsFixed(0),
                  style: TextStyle(
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black.withValues(alpha: 0.7)
                          : Colors.white,
                      fontSize: 65,
                    fontWeight: FontWeight.bold
                  )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Good', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.black
                    : Colors.white, fontSize: 16),),
              )
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Air Quality is considered satisfactory and air pollution passes little or no risk.',
              style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.black
                  : Colors.white, fontSize: 16),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AirQualityAnimated(currentValue: widget.currentValue),
          )
          // Sun and Moon icons
        ],
      ),
    );
  }
}