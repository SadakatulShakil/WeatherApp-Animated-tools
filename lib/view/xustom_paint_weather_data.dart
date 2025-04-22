import 'package:flutter/material.dart';
import 'dart:math';

class WeatherGaugeWidget extends StatefulWidget {
  final double windSpeed; // in mph
  final double windDirection; // 0-360 degrees (0=N, 90=E, 180=S, 270=W)
  final double windGusts; // in mph
  final double pressure; // 0-100 scale

  const WeatherGaugeWidget({
    super.key,
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
    required this.pressure,
  });

  @override
  State<WeatherGaugeWidget> createState() => _WeatherGaugeWidgetState();
}

class _WeatherGaugeWidgetState extends State<WeatherGaugeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _windAnimation;
  late Animation<double> _pressureAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Normalize wind direction to 0-1 (0-360°)
    final windNormalized = (widget.windDirection % 360) / 360;
    // Normalize pressure to 0-1 (assuming 0-100 scale)
    final pressureNormalized = widget.pressure.clamp(0.0, 100.0) / 100;

    _windAnimation = Tween<double>(begin: 0, end: windNormalized).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _pressureAnimation = Tween<double>(begin: 0, end: pressureNormalized).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Wind Compass
          _buildWindCompass(),

          // Pressure Meter
          _buildPressureMeter(),
        ],
      ),
    );
  }

  Widget _buildWindCompass() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wind compass
        SizedBox(
          width: 120,
          height: 120,
          child: AnimatedBuilder(
            animation: _windAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _WindCompassPainter(_windAnimation.value, widget.windSpeed),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Wind speed and gusts
        Column(
          children: [
            Text(
              '${widget.windSpeed.toStringAsFixed(1)} mph',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Gusts: ${widget.windGusts.toStringAsFixed(1)} mph',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPressureMeter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pressure gauge
        SizedBox(
          width: 120,
          height: 120,
          child: AnimatedBuilder(
            animation: _pressureAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _PressureGaugePainter(_pressureAnimation.value, widget.pressure),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Pressure value and status
        Column(
          children: [
            Text(
              '${widget.pressure.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _getPressureStatus(widget.pressure),
              style: TextStyle(
                fontSize: 14,
                color: _getPressureColor(widget.pressure),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getPressureStatus(double pressure) {
    if (pressure < 50) return 'LOW';
    if (pressure < 80) return 'MEDIUM';
    return 'HIGH';
  }

  Color _getPressureColor(double pressure) {
    if (pressure < 50) return Colors.green;
    if (pressure < 80) return Colors.orange;
    return Colors.red;
  }
}

class _WindCompassPainter extends CustomPainter {
  final double direction; // 0-1 (0=N, 0.25=E, 0.5=S, 0.75=W)
  final double speed;

  _WindCompassPainter(this.direction, this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw compass circle
    final circlePaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius - 10, circlePaint);

    // Draw cardinal directions (N at top)
    const directions = ['N', 'E', 'S', 'W'];
    const directionAngles = [-pi/2, 0, pi/2, pi]; // Adjusted angles for N at top

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < directions.length; i++) {
      final angle = directionAngles[i];
      final textOffset = Offset(
        center.dx + cos(angle) * (radius - 20),
        center.dy + sin(angle) * (radius - 20),
      );

      textPainter.text = TextSpan(
        text: directions[i],
        style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        textOffset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Draw wind direction indicator (adjusted for N at top)
    final indicatorAngle = (direction * 2 * pi) - (pi / 2);
    final indicatorPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final indicatorPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(
        center.dx + cos(indicatorAngle) * (radius - 15),
        center.dy + sin(indicatorAngle) * (radius - 15),
      )
      ..lineTo(
        center.dx + cos(indicatorAngle + pi * 0.9) * 10,
        center.dy + sin(indicatorAngle + pi * 0.9) * 10,
      )
      ..close();

    canvas.drawPath(indicatorPath, indicatorPaint);

    // Draw speed indicator
    final speedRadius = radius * 0.7 * (speed / 30).clamp(0.1, 1.0);
    final speedPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, speedRadius, speedPaint);
  }

  @override
  bool shouldRepaint(covariant _WindCompassPainter oldDelegate) {
    return oldDelegate.direction != direction || oldDelegate.speed != speed;
  }
}

class _PressureGaugePainter extends CustomPainter{
  final double value; // 0-1
  final double pressureValue; // Actual pressure value (e.g., 1002)
  _PressureGaugePainter(this.value, this.pressureValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 1.3);
    final radius = size.width / 1.5;

    // === ARC GRADIENT SETUP ===
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 💡 Updated: Use a wider sweep gradient for 270° arc
    final gradient = SweepGradient(
      startAngle: 3 * pi / 4, // 225°
      endAngle: 3 * pi / 2 + 3 * pi / 4, // 495°, covers 270°
      colors: [
        Colors.green,
        Colors.lime,
        Colors.yellow,
        Colors.orange,
        Colors.deepOrange,
        Colors.red,
      ],
      stops: [
        -0.00, // Green
        0.10, // Lime
        0.20, // Yellow
        0.30, // Orange
        0.40, // Deep Orange
        0.70, // Red starts
      ],
      transform: GradientRotation(3 * pi / 4), // Rotate to arc start
    );


    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    // 🟢 Draw arc with wider sweep — from 225° to 315° (approx. 270° total)
    final startAngle = 3 * pi / 4; // ≈ 225°
    final sweepAngle = 3 * pi / 2; // ≈ 270°
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // === NEEDLE CALCULATION ===
    // 💡 Update needle angle range to match new arc
    final needleAngle = startAngle + value * sweepAngle;

    final needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final needlePath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(
        center.dx + cos(needleAngle) * (radius - 10),
        center.dy + sin(needleAngle) * (radius - 10),
      )
      ..lineTo(
        center.dx + cos(needleAngle + pi * 0.9) * 12,
        center.dy + sin(needleAngle + pi * 0.9) * 12,
      )
      ..close();

    canvas.drawPath(needlePath, needlePaint);
    canvas.drawCircle(center, 12, Paint()..color = Colors.blue.shade200);

    // === LABELS ===
    const labels = ['LOW', 'MEDIUM', 'HIGH'];

    // 💡 Adjust label angles to spread across 270°
    final labelAngles = [
      startAngle,                     // LOW
      startAngle + sweepAngle / 2,   // MEDIUM
      startAngle + sweepAngle        // HIGH
    ];

    final textStyle = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    for (int i = 0; i < labels.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      final angle = labelAngles[i];
      final labelOffset = Offset(
        center.dx + cos(angle) * (radius - 20) - textPainter.width / 2,
        center.dy + sin(angle) * (radius - 45) - textPainter.height / 2,
      );

      textPainter.paint(canvas, labelOffset);
    }

    // === VALUE TEXT ===
    final valueText = TextSpan(
      text: pressureValue.toStringAsFixed(0),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

    final valuePainter = TextPainter(
      text: valueText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    valuePainter.layout();

    // 💡 Keep this at bottom center
    valuePainter.paint(
      canvas,
      Offset(center.dx - valuePainter.width / 2, center.dy + radius - 50),
    );
  }

  @override
  bool shouldRepaint(covariant _PressureGaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.pressureValue != pressureValue;
  }
}
