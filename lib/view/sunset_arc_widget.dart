import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    double totalMinutes =
    _timeDiff(widget.moonrise, widget.moonset).inMinutes.toDouble();

    double currentMinutes;

    // If current time is before moonrise, set currentMinutes = 0
    final nowMinutes = widget.currentTime.hour * 60 + widget.currentTime.minute;
    final riseMinutes = widget.moonrise.hour * 60 + widget.moonrise.minute;

    if (nowMinutes < riseMinutes) {
      currentMinutes = 0;
    } else {
      currentMinutes =
          _timeDiff(widget.moonrise, widget.currentTime).inMinutes.toDouble();
    }

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
          key: const Key("Sunset"),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.5) {
              _startAnimation();
            }
          },
          child: CustomPaint(
            size: Size(140, 70), // Width and Height of the widget
            painter: ArcPainter(progress: _position.value),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.moonrise.format(context)}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              '${widget.moonset.format(context)}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;

  ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
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
              Colors.purple.shade400.withOpacity(0.6),
              Colors.blue.shade200.withOpacity(0.07),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(arcRect)
          ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // 3. Draw the Arc Stroke
    final Paint arcPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke;

    canvas.drawArc(arcRect, math.pi, math.pi, false, arcPaint);

    // 4. Draw the Bottom Straight Line
    final Paint linePaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2;
    canvas.drawLine(
      Offset(-15, size.height),
      Offset(size.width + 15, size.height),
      linePaint,
    );

    // 5. Draw the Dots
    final Paint dotPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, size.height), 4, dotPaint);
    canvas.drawCircle(Offset(size.width, size.height), 4, dotPaint);

    // 6. Draw the Moon Icon
    final angle = math.pi + (math.pi * progress);
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
      sunOffset - const Offset(14, 14),
    ); // Centered nicely
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
