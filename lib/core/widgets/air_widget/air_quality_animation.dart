import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/theme_controller.dart';

class AirQualityAnimated extends StatefulWidget {
  final double currentValue; // Expected between 0-100
  const AirQualityAnimated({super.key, required this.currentValue});

  @override
  State<AirQualityAnimated> createState() => _AirQualityAnimatedState();
}

class _AirQualityAnimatedState extends State<AirQualityAnimated> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  final ThemeController themeController = Get.find<ThemeController>();

  void _startAnimation() {
    _controller.reset();
    _position = Tween<double>(begin: 0, end: widget.currentValue / 100).animate(
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
                children: [
                  // Background faded line
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Gradient line
                  Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.orange, Colors.red],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Moving glowing circle
                  Positioned(
                    left: (_position.value) * width - 8,
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
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ভাল', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                ? Colors.black
                : Colors.white,)),
            Text('বিপজ্জনক', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                ? Colors.black
                : Colors.white,)),
          ],
        )
      ],
    );
  }
}
