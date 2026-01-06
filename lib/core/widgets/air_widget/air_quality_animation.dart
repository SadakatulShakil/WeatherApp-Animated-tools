import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/theme_controller.dart';

class AirQualityAnimated extends StatefulWidget {
  final double currentValue; // The AQI value (e.g., 45, 120, 250)
  const AirQualityAnimated({super.key, required this.currentValue});

  @override
  State<AirQualityAnimated> createState() => _AirQualityAnimatedState();
}

class _AirQualityAnimatedState extends State<AirQualityAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  final ThemeController themeController = Get.find<ThemeController>();

  // Define the maximum value for the visual bar (usually 300 or 500 for AQI)
  final double _maxAQI = 300.0;
  bool isBangla = Get.locale?.languageCode == 'bn';

  // Helper to get status text and color based on value
  // You can adjust these numbers if you want "40" to be unhealthy
  Map<String, dynamic> _getAQIStatus(double value) {

    if (value <= 50) {
      return {
        'label': isBangla ? 'ভালো' : 'Good',
        'color': Colors.green
      };
    } else if (value <= 100) {
      return {
        'label': isBangla ? 'মধ্যম' : 'Moderate',
        'color': Colors.yellow.shade700
      };
    } else if (value <= 150) {
      return {
        'label': isBangla ? 'সংবেদনশীল গোষ্ঠীর জন্য \nঅস্বাস্থ্যকর' : 'Unhealthy for Sensitive Groups',
        // Shortened for UI if needed: 'সংবেদনশীল'
        'color': Colors.orange
      };
    } else if (value <= 200) {
      return {
        'label': isBangla ? 'অস্বাস্থ্যকর' : 'Unhealthy',
        'color': Colors.red
      };
    } else if (value <= 300) {
      return {
        'label': isBangla ? 'খুবই অস্বাস্থ্যকর' : 'Very Unhealthy',
        'color': Colors.purple
      };
    } else {
      return {
        'label': isBangla ? 'ঝুঁকিপূর্ণ' : 'Hazardous',
        'color': Colors.purple.shade900
      };
    }
  }

  void _startAnimation() {
    // Clamp value so it doesn't exceed the bar width
    double normalizedValue = (widget.currentValue / _maxAQI).clamp(0.0, 1.0);

    _controller.reset();
    _position = Tween<double>(begin: 0, end: normalizedValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _position = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Get current status details
    final status = _getAQIStatus(widget.currentValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisibilityDetector(
          key: const Key("air_quality"),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.5) {
              _startAnimation();
            }
          },
          child: AnimatedBuilder(
            animation: _position,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.centerLeft,
                clipBehavior: Clip.none, // Allow dot to overlap slightly if needed
                children: [
                  // 1. Background Gradient Bar
                  Container(
                    height: 8,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.green,        // 0-50
                          Colors.yellow,       // 51-100
                          Colors.orange,       // 101-150
                          Colors.red,          // 151-200
                          Colors.purple,       // 201-300
                        ],
                        // These stops help distribute the colors correctly across 0-300
                        stops: [0.0, 0.2, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // 2. Moving Glowing Circle
                  Positioned(
                    // Calculate left position based on animation value (0.0 to 1.0)
                    // Subtract 8 (half of dot width 16) to center it on the value
                    left: (_position.value * (width - 32)), // width - padding adjustment
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black87
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeController.themeMode.value == ThemeMode.light
                                ? Colors.black.withValues(alpha: 0.6)
                                : Colors.white.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // 3. Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                isBangla? 'ভালো (০)': 'Good (0)',
                style: TextStyle(
                  fontSize: 12,
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.grey[600]
                      : Colors.grey[400],
                )
            ),
            // Dynamic Middle Label showing current status
            Text(
              "${status['label']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status['color'],
              ),
            ),
            Text(
                isBangla? 'ঝুঁকিপূর্ণ (৩০০+)':'Hazardous (300+)',
                style: TextStyle(
                  fontSize: 12,
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.grey[600]
                      : Colors.grey[400],
                )
            ),
          ],
        )
      ],
    );
  }
}