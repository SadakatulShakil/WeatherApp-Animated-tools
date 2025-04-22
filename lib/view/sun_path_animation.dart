import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SunriseSunsetWidget extends StatefulWidget {
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final TimeOfDay currentTime;
  const SunriseSunsetWidget({super.key, required this.sunrise, required this.sunset, required this.currentTime});

  @override
  State<SunriseSunsetWidget> createState() => _SunriseSunsetWidgetState();
}

class _SunriseSunsetWidgetState extends State<SunriseSunsetWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  double percent = 0.0;

  void _startAnimation() {
    _controller.reset();
    _position = Tween<double>(begin: 0, end: percent).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    double totalMinutes = _timeDiff(widget.sunrise, widget.sunset).inMinutes.toDouble();
    double currentMinutes = _timeDiff(widget.sunrise, widget.currentTime).inMinutes.toDouble();
    percent = (currentMinutes / totalMinutes).clamp(0, 1);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _position = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  Duration _timeDiff(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return Duration(minutes: endMinutes - startMinutes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Sunrise & Sunset', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 10),
        VisibilityDetector(
          key: const Key("Sunrise_Sunset"),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.5) {
              _startAnimation();
            }
          },
          child: AnimatedBuilder(
            animation: _position,
            builder: (context, _) {
              return Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _position.value,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (_position.value) * MediaQuery.of(context).size.width - 35, // Adjust `-12` for half icon width
                    top: 2,
                    child: Icon(Icons.wb_sunny, color: Colors.orange, size: 18),
                  )
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.sunrise.format(context)}', style: const TextStyle(color: Colors.white)),
            Text('${widget.sunset.format(context)}', style: const TextStyle(color: Colors.white)),
          ],
        )
      ],
    );
  }
}
