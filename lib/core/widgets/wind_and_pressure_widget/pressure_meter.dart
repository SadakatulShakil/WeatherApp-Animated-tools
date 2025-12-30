import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/theme_controller.dart';

class PressureMeter extends StatefulWidget {
  final double pressureValue;

  const PressureMeter({super.key, required this.pressureValue});

  @override
  State<PressureMeter> createState() => _PressureMeterState();
}

class _PressureMeterState extends State<PressureMeter>
    with SingleTickerProviderStateMixin {
  final ThemeController themeController = Get.find<ThemeController>();
  late AnimationController _controller;
  late Animation<double> _animation;

  void _startAnimation() {
    _controller.reset();
    _animation = Tween<double>(begin: 0, end: widget.pressureValue/20).animate(
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

    // Initialize with dummy value (0) to avoid null errors
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<GaugeRange> _gradientTickStyleArc() {
    List<GaugeRange> ranges = [];
    int totalTicks = 180;
    double step = 1.5; // range size

    for (int i = 0; i < totalTicks; i++) {
      double start = i * step;
      double end = start + step;

      // Transparent every alternate tick
      if (i % 2 == 0) {
        ranges.add(
          GaugeRange(
            startValue: start,
            endValue: end,
            color: Colors.transparent,
            startWidth: 35,
            endWidth: 35,
          ),
        );
        continue;
      }

      // White tick marks
      if (i == 1 || i == 119) {
        ranges.add(
          GaugeRange(
            startValue: start,
            endValue: end,
            color: Colors.white,
            startWidth: 20,
            endWidth: 20,
          ),
        );
        continue;
      }

      // Multi-color gradient with more green
      Color color;
      double ratio = i / totalTicks;

      if (ratio < 0.5) {
        color = Color.lerp(Colors.green, Colors.yellow, ratio / 0.5)!;
      } else if (ratio < 0.7) {
        color = Color.lerp(Colors.yellow, Colors.orange, (ratio - 0.5) / 0.2)!;
      } else {
        color = Color.lerp(Colors.orange, Colors.red, (ratio - 0.7) / 0.3)!;
      }

      ranges.add(
        GaugeRange(
          startValue: start,
          endValue: end,
          color: color,
          startWidth: 35,
          endWidth: 35,
        ),
      );
    }
    return ranges;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key("pressure_meter"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          _startAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            width: 160,
            height: 200,
            child:
            /// Pressure Meter01
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  showTicks: false,
                  showLabels: false,
                  radiusFactor: 0.9,
                  axisLineStyle: const AxisLineStyle(
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Colors.transparent,
                  ),
                ),
                RadialAxis(
                  minimum: 0,
                  maximum: 180,
                  showTicks: false,
                  showLabels: false,
                  startAngle: 130,
                  radiusFactor: 0.9,
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: _animation.value,
                      needleLength: 0.9,
                      needleStartWidth: 0,
                      needleEndWidth: 5,
                      needleColor: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      knobStyle: KnobStyle(
                        knobRadius: 0.072,
                        color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        borderWidth: 1,
                      ),
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.4,
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.pressureValue.toStringAsFixed(0),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: themeController.themeMode.value == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'hPa',
                            style: TextStyle(
                              color: themeController.themeMode.value == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GaugeAnnotation(
                      widget: Text(
                        'Low',
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      angle: 130,
                      positionFactor: 1.2,
                    ),
                    GaugeAnnotation(
                      widget: Text(
                        'High',
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      angle: 50,
                      positionFactor: 1.2,
                    ),
                    // White spike at the START (130°)
                    GaugeAnnotation(
                      widget: Transform.rotate(
                        angle: -50 * (3.1415926535 / 180), // Rotate the spike to align with the arc
                        child: Icon(
                          Icons.linear_scale_outlined,
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          size: 16,
                        ),
                      ),
                      angle: 128,
                      positionFactor: 0.9, // Adjust position closer to the arc
                    ),
                    // White spike at the END (50°)
                    GaugeAnnotation(
                      widget: Transform.rotate(
                        angle: 48 * (3.1415926535 / 180), // Rotate the spike to align with the arc
                        child: Icon(
                          Icons.linear_scale_outlined,
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          size: 16,
                        ),
                      ),
                      angle: 52,
                      positionFactor: 0.9, // Adjust position closer to the arc
                    ),
                  ],
                  axisLineStyle: const AxisLineStyle(
                    gradient: SweepGradient(
                      colors: <Color>[Colors.green, Colors.lime, Colors.yellow, Colors.red],
                      stops: <double>[0.15, 0.45, 0.70, 0.85],
                    ),
                    thickness: 30,
                    dashArray: <double>[1.5, 1],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
