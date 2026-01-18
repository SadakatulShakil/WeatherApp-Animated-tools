import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../controllers/theme_controller.dart';

class SunsetArcWidget extends StatefulWidget {
  final TimeOfDay moonrise;
  final TimeOfDay moonset;
  final TimeOfDay currentTime;
  final String languageCode;
  final String svgPath;

  const SunsetArcWidget({
    super.key,
    required this.moonrise,
    required this.moonset,
    required this.currentTime,
    required this.languageCode,
    this.svgPath = 'assets/svg/moonrise.svg', // Ensure this path is in pubspec.yaml
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

  // Updated state variables for flutter_svg 2.x
  Picture? _moonPicture;
  Size _svgSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _calculatePercent();
    _loadSvg();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _position = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  // Modern way to load SVG for CustomPainter in flutter_svg 2.x
  Future<void> _loadSvg() async {
    try {
      final String rawSvg = await rootBundle.loadString(widget.svgPath);
      final SvgLoader loader = SvgStringLoader(rawSvg);
      final PictureInfo pictureInfo = await vg.loadPicture(loader, null);

      setState(() {
        _moonPicture = pictureInfo.picture;
        _svgSize = pictureInfo.size;
      });
    } catch (e) {
      debugPrint("Error loading SVG: $e");
    }
  }

  void _startAnimation() {
    _controller.reset();
    _position = Tween<double>(begin: 0, end: percent).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  String englishNumberToBangla(String input) {
    const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], bangla[i]);
    }
    return input;
  }

  void _calculatePercent() {
    int nowMin = widget.currentTime.hour * 60 + widget.currentTime.minute;
    int riseMin = widget.moonrise.hour * 60 + widget.moonrise.minute;
    int setMin = widget.moonset.hour * 60 + widget.moonset.minute;

    double totalDuration;
    double elapsed;

    if (riseMin < setMin) {
      totalDuration = (setMin - riseMin).toDouble();
      if (nowMin < riseMin) {
        elapsed = 0;
      } else if (nowMin > setMin) elapsed = totalDuration;
      else elapsed = (nowMin - riseMin).toDouble();
    } else {
      totalDuration = ((24 * 60) - riseMin + setMin).toDouble();
      if (nowMin >= riseMin) {
        elapsed = (nowMin - riseMin).toDouble();
      } else if (nowMin <= setMin) elapsed = ((24 * 60) - riseMin + nowMin).toDouble();
      else elapsed = 0;
    }
    percent = (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    // It's good practice to dispose the picture
    _moonPicture?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("CheckMoonValue: ${widget.moonrise} - ${widget.moonset} - Percent: $percent");
    return Column(
      children: [
        const SizedBox(height: 10),
        VisibilityDetector(
          key: const Key("SunsetArc"),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.5) {
              _startAnimation();
            }
          },
          child: CustomPaint(
            size: const Size(140, 70),
            painter: ArcPainter(
              controller: themeController,
              progress: _position.value,
              moonPicture: _moonPicture,
              svgSize: _svgSize,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.languageCode == 'bn'
                  ? englishNumberToBangla(widget.moonrise.format(context)) : widget.moonrise.format(context),
              style: TextStyle(color: themeController.themeMode.value == ThemeMode.light ? Colors.black : Colors.white, fontSize: 12),
            ),
            Text(
              widget.languageCode == 'bn'
                  ? englishNumberToBangla(widget.moonset.format(context)) : widget.moonset.format(context),
              style: TextStyle(color: themeController.themeMode.value == ThemeMode.light ? Colors.black : Colors.white, fontSize: 12),
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
  final Picture? moonPicture;
  final Size svgSize;

  ArcPainter({
    required this.progress,
    required this.controller,
    this.moonPicture,
    required this.svgSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2.2;
    final center = Offset(size.width / 2, size.height);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw Background Path Gradient
    final Path path = Path()
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
    // 4. Calculate Position for Moon
    final angle = math.pi + (math.pi * progress.clamp(0.0, 1.0));
    final Offset moonCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    // 5. Draw the SVG Moon icon
    if (moonPicture != null) {
      const double targetDim = 22.0; // Size of the moon icon

      canvas.save();
      canvas.translate(moonCenter.dx, moonCenter.dy);

      // Scale to target size
      final double scale = targetDim / math.max(svgSize.width, svgSize.height);
      canvas.scale(scale);

      // Center the picture relative to the moonCenter
      canvas.translate(-svgSize.width / 2, -svgSize.height / 2);

      canvas.drawPicture(moonPicture!);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.moonPicture != moonPicture;
  }
}