import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/theme_controller.dart';

class SunsetArcWidget extends StatefulWidget {
  final TimeOfDay moonrise;
  final TimeOfDay moonset;
  final TimeOfDay currentTime;

  const SunsetArcWidget({
    super.key,
    required this.moonrise,
    required this.moonset,
    required this.currentTime,
  });

  @override
  State<SunsetArcWidget> createState() => _SunsetArcWidgetState();
}

class _SunsetArcWidgetState extends State<SunsetArcWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  final ThemeController themeController = Get.find<ThemeController>();
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

  final bool isBangla = Get.locale?.languageCode == 'bn';

  String englishNumberToBangla(String input) {
    const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], bangla[i]);
    }
    return input;
  }

  @override
  void initState() {
    super.initState();
    _calculatePercent();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _position = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  // Updated Logic to handle time calculation correctly
  void _calculatePercent() {
    int nowMin = widget.currentTime.hour * 60 + widget.currentTime.minute;
    int riseMin = widget.moonrise.hour * 60 + widget.moonrise.minute;
    int setMin = widget.moonset.hour * 60 + widget.moonset.minute;

    double totalDuration;
    double elapsed;

    // Check if the event crosses midnight (e.g., Rise 18:00 -> Set 06:00)
    if (riseMin < setMin) {
      // Case 1: Same day event (e.g., Rise 09:00, Set 21:00)
      totalDuration = (setMin - riseMin).toDouble();

      if (nowMin < riseMin) {
        // Before Rise -> Stay at Start (0%)
        elapsed = 0;
      } else if (nowMin > setMin) {
        // After Set -> Stay at End (100%)
        elapsed = totalDuration;
      } else {
        // Active Duration
        elapsed = (nowMin - riseMin).toDouble();
      }
    } else {
      // Case 2: Crosses midnight (e.g., Rise 18:00, Set 06:00)
      totalDuration = ((24 * 60) - riseMin + setMin).toDouble();

      if (nowMin >= riseMin) {
        // Evening before midnight (e.g., Now 20:00 vs Rise 18:00) -> Active
        elapsed = (nowMin - riseMin).toDouble();
      } else if (nowMin <= setMin) {
        // Morning after midnight (e.g., Now 04:00 vs Set 06:00) -> Active
        elapsed = ((24 * 60) - riseMin + nowMin).toDouble();
      } else {
        // Time is between Set and Rise (e.g., Now 12:00) -> Moon is down
        // Stay at Start (0%)
        elapsed = 0;
      }
    }

    // Ensure percent is between 0.0 and 1.0
    percent = (elapsed / totalDuration).clamp(0.0, 1.0);
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
        const SizedBox(height: 10),
        VisibilityDetector(
          key: const Key("Sunset"),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.5) {
              _startAnimation();
            }
          },
          child: CustomPaint(
            size: Size(140, 70),
            painter: ArcPainter(controller: themeController, progress: _position.value),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isBangla? englishNumberToBangla(widget.moonrise.format(context)) : widget.moonrise.format(context),
              style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.black
                  : Colors.white),
            ),
            Text(
              isBangla? englishNumberToBangla(widget.moonset.format(context)) : widget.moonset.format(context),
              style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.black
                  : Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  final ThemeController controller;

  ArcPainter({required this.progress, required this.controller});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.2;
    final center = Offset(size.width / 2, size.height);

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    // 1. Create Path
    final Path path =
    Path()
      ..moveTo(0, size.height)
      ..arcTo(arcRect, math.pi, math.pi, false)
      ..lineTo(size.width, size.height)
      ..close();

    // 2. Fill Path with Gradient
    final Paint fillPaint =
    Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFFD777FF).withValues(alpha: 0.7),
          Color(0x000c2a96),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(arcRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // 3. Draw the Arc Stroke
    final Paint arcPaint =
    Paint()
      ..color = controller.themeMode.value == ThemeMode.light
          ? Colors.black.withValues(alpha: 0.7)
          : Color(0xFFD777FF)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawArc(arcRect, math.pi, math.pi, false, arcPaint);

    // 4. Draw the Bottom Straight Line
    final Paint linePaint =
    Paint()
      ..color = controller.themeMode.value == ThemeMode.light
          ? Colors.black.withValues(alpha: 0.7)
          : Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(-5, size.height),
      Offset(size.width + 5, size.height),
      linePaint,
    );

    // 5. Draw the Dots
    final Paint dotPaint =
    Paint()
      ..color = controller.themeMode.value == ThemeMode.light
          ? Colors.black.withValues(alpha: 0.7)
          : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(6, size.height), 4, dotPaint);
    canvas.drawCircle(Offset(size.width-6, size.height), 4, dotPaint);

    // 6. Draw the Moon Icon
    // Clamp progress for safety in drawing
    final safeProgress = progress.clamp(0.0, 1.0);
    final angle = math.pi + (math.pi * safeProgress);
    final Offset sunOffset = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.nights_stay.codePoint),
        style: TextStyle(
          fontSize: 25,
          fontFamily: Icons.nightlight_round.fontFamily,
          color: Colors.purple,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      sunOffset - const Offset(10, 15),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}