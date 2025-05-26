import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/theme_controller.dart';

class SunriseArcWidget extends StatefulWidget {
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final TimeOfDay currentTime;

  const SunriseArcWidget({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.currentTime,
  });

  @override
  State<SunriseArcWidget> createState() => _SunriseArcWidgetState();
}

class _SunriseArcWidgetState extends State<SunriseArcWidget> with SingleTickerProviderStateMixin {
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
        const SizedBox(height: 10),
        VisibilityDetector(
          key: const Key("Sunrise"),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.5) {
              _startAnimation();
            }
          },
          child: CustomPaint(
            size: Size(140, 70), // Width and Height of the widget
            painter: ArcPainter(controller: themeController, progress: _position.value),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.sunrise.format(context)}', style:  TextStyle(color: themeController.themeMode.value == ThemeMode.light
                ? Colors.black
                : Colors.white)),
            Text('${widget.sunset.format(context)}', style:  TextStyle(color: themeController.themeMode.value == ThemeMode.light
                ? Colors.black
                : Colors.white)),
          ],
        )
      ],
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  final ThemeController controller;

  ArcPainter({
    required this.progress,
    required this.controller
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.2;
    final center = Offset(size.width / 2, size.height);

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    // 1. Create Path
    final Path path = Path()
      ..moveTo(0, size.height)
      ..arcTo(arcRect, math.pi, math.pi, false)
      ..lineTo(size.width, size.height)
      ..close();

    // 2. Fill Path with Gradient
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.yellow.shade400.withOpacity(0.6),
          Colors.blue.shade200.withOpacity(0.07),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(arcRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // 3. Draw the Arc Stroke
    final Paint arcPaint = Paint()
      ..color = controller.themeMode.value == ThemeMode.light
          ? Colors.black
          : Colors.white.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawArc(arcRect, math.pi, math.pi, false, arcPaint);

    // 4. Draw the Bottom Straight Line
    final Paint linePaint = Paint()
      ..color = controller.themeMode.value == ThemeMode.light
          ? Colors.black
          : Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(Offset(-5, size.height), Offset(size.width+5, size.height), linePaint);

    // 5. Draw the Dots
    final Paint dotPaint = Paint()
      ..color = controller.themeMode.value == ThemeMode.light
          ? Colors.black
          : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(6, size.height), 4, dotPaint);
    canvas.drawCircle(Offset(size.width-6, size.height), 4, dotPaint);

    // 6. Draw the Sun Icon
    final angle = math.pi + (math.pi * progress);
    final Offset sunOffset = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '☀️', // or use any Flutter Icon
        style: TextStyle(fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, sunOffset - const Offset(10, 10)); // Centered nicely
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
