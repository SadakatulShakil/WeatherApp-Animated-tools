import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AirQualityWidget extends StatefulWidget {
  final double currentValue; // Expected between 0-100
  const AirQualityWidget({super.key, required this.currentValue});

  @override
  State<AirQualityWidget> createState() => _AirQualityWidgetState();
}

class _AirQualityWidgetState extends State<AirQualityWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Air Quality', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 10),
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
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
          children: const [
            Text('Low', style: TextStyle(color: Colors.white)),
            Text('High', style: TextStyle(color: Colors.white)),
          ],
        )
      ],
    );
  }
}
