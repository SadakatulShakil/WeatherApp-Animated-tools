import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PressureMeter extends StatefulWidget {
  final double pressureValue;

  const PressureMeter({super.key, required this.pressureValue});

  @override
  State<PressureMeter> createState() => _PressureMeterState();
}

class _PressureMeterState extends State<PressureMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void _startAnimation() {
    _controller.reset();
    _animation = Tween<double>(begin: 0, end: widget.pressureValue).animate(
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
            width: 150,
            height: 180,
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
                      needleColor: Colors.white,
                      knobStyle: const KnobStyle(
                        knobRadius: 0.072,
                        color: Colors.white,
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
                            '1002',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'hPa',
                            style: TextStyle(
                              color: Colors.white,
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
                          color: Colors.white,
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
                          color: Colors.white,
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
                          color: Colors.white,
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
                          color: Colors.white,
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
                /// Pressure Meter02
            // SfRadialGauge(
            //   axes: <RadialAxis>[
            //     RadialAxis(
            //       showTicks: false,
            //       showLabels: false,
            //       radiusFactor: 0.9,
            //       axisLineStyle: const AxisLineStyle(
            //         thicknessUnit: GaugeSizeUnit.factor,
            //         color: Colors.transparent,
            //       ),
            //     ),
            //     RadialAxis(
            //       minimum: 0,
            //       maximum: 180,
            //       showTicks: false,
            //       showLabels: false,
            //       startAngle: 130,
            //       radiusFactor: 0.9,
            //       pointers: <GaugePointer>[
            //         NeedlePointer(
            //           value: _animation.value,
            //           needleLength: 0.9,
            //           needleStartWidth: 0,
            //           needleEndWidth: 5,
            //           needleColor: Colors.white,
            //           knobStyle: const KnobStyle(
            //             knobRadius: 0.072,
            //             color: Colors.white,
            //             borderWidth: 1,
            //           ),
            //         ),
            //       ],
            //       annotations: <GaugeAnnotation>[
            //         GaugeAnnotation(
            //           angle: 90,
            //           positionFactor: 0.4,
            //           widget: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text(
            //                 '1002',
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.white,
            //                   fontSize: 18,
            //                 ),
            //               ),
            //               Text(
            //                 'hPa',
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 15,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         GaugeAnnotation(
            //             widget: Text('Low',
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 12,
            //                   fontWeight: FontWeight.bold)
            //             ),
            //           angle: 130,
            //           positionFactor: 1.2,
            //         ),
            //         GaugeAnnotation(
            //           widget: Text('High',
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 12,
            //                   fontWeight: FontWeight.bold)
            //           ),
            //           angle: 50,
            //           positionFactor: 1.2,
            //         )
            //       ],
            //       axisLineStyle: const AxisLineStyle(
            //         gradient: SweepGradient(
            //           colors: <Color>[Colors.green, Colors.lime, Colors.yellow, Colors.red],
            //           stops: <double>[0.15, 0.45, 0.70, 0.85],
            //         ),
            //         thickness: 30,
            //         dashArray: <double>[1.5, 1],
            //       ),
            //     ),
            //   ],
            // ),

            /// Pressure Meter03
            // SfRadialGauge(
            //   axes: <RadialAxis>[
            //     RadialAxis(
            //       minimum: 0,
            //       maximum: 180,
            //       showLabels: false,
            //       showTicks: false,
            //       startAngle: 130,
            //       endAngle: 50,
            //       radiusFactor: 0.95,
            //       axisLineStyle: const AxisLineStyle(
            //         thicknessUnit: GaugeSizeUnit.factor,
            //         color: Colors.transparent,
            //       ),
            //       ranges: _gradientTickStyleArc(),
            //       pointers: <GaugePointer>[
            //         NeedlePointer(
            //           value: _animation.value,
            //           needleLength: 0.9,
            //           needleStartWidth: 0,
            //           needleEndWidth: 5,
            //           needleColor: Colors.white,
            //           knobStyle: const KnobStyle(
            //             knobRadius: 0.072,
            //             color: Colors.white,
            //             borderWidth: 1,
            //           ),
            //         ),
            //       ],
            //       annotations: <GaugeAnnotation>[
            //         GaugeAnnotation(
            //           widget: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text(
            //                 '1002',
            //                 style: const TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //               const Text(
            //                 'hPa',
            //                 style: TextStyle(color: Colors.white70),
            //               ),
            //             ],
            //           ),
            //           angle: 90,
            //           positionFactor: 0.4,
            //         ),
            //         const GaugeAnnotation(
            //           widget: Text("Low",
            //               style: TextStyle(color: Colors.white70, fontSize: 12)),
            //           angle: 135,
            //           positionFactor: 1.2,
            //         ),
            //         const GaugeAnnotation(
            //           widget: Text("High",
            //               style: TextStyle(color: Colors.white70, fontSize: 12)),
            //           angle: 45,
            //           positionFactor: 1.2,
            //         ),
            //       ],
            //       majorTickStyle: const MajorTickStyle(
            //         thickness: 1,
            //         length: 20,
            //         color: Colors.white,
            //       ),
            //       /// Hide default ticks, we will draw our custom ticks
            //       minorTicksPerInterval: 0,
            //       interval: 150 / 75,
            //       // now we inject our custom ticks below
            //       axisLabelStyle: const GaugeTextStyle(color: Colors.transparent),
            //     )
            //   ],
            // ),
          );
        },
      ),
    );
  }
}

// SfRadialGauge(
// axes: <RadialAxis>[
// RadialAxis(
// showTicks: false,
// showLabels: false,
// startAngle: 180,
// endAngle: 180,
// radiusFactor: model.isWebFullView ? 0.8 : 0.9,
// axisLineStyle: const AxisLineStyle(
// // Dash array not supported in web
// thickness: 30,
// dashArray: <double>[8, 10],
// ),
// ),
// RadialAxis(
// showTicks: false,
// showLabels: false,
// startAngle: 180,
// radiusFactor: model.isWebFullView ? 0.8 : 0.9,
// annotations: <GaugeAnnotation>[
// GaugeAnnotation(
// angle: 270,
// widget: Text(
// ' 63%',
// style: TextStyle(
// fontStyle: FontStyle.italic,
// fontFamily: 'Times',
// fontWeight: FontWeight.bold,
// fontSize: isCardView ? 18 : 25,
// ),
// ),
// ),
// ],
// axisLineStyle: const AxisLineStyle(
// color: Color(0xFF00A8B5),
// gradient: SweepGradient(
// colors: <Color>[Color(0xFF06974A), Color(0xFFF2E41F)],
// stops: <double>[0.25, 0.75],
// ),
// thickness: 30,
// dashArray: <double>[8, 10],
// ),
// ),
// ],
// )
