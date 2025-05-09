import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WindCompass extends StatefulWidget {
  final double windSpeed;      // e.g., 16.0
  final double windDirection;  // in degrees, 0-360 (0 = North)

  const WindCompass({
    Key? key,
    required this.windSpeed,
    required this.windDirection,
  }) : super(key: key);

  @override
  State<WindCompass> createState() => _WindCompassState();
}

class _WindCompassState extends State<WindCompass>
    with SingleTickerProviderStateMixin {
  double animatedValue = 0;
  late AnimationController _controller;
  late Animation<double> _needleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _needleAnimation = Tween<double>(begin: 0, end: widget.windSpeed).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void animateNeedle() {
    _controller.reset();
    _needleAnimation = Tween<double>(
      begin: 0,
      end: widget.windSpeed,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAxisLabelCreated(AxisLabelCreatedArgs args) {
    if(args.text == '0'){
      args.text = 'N';
    } else if (args.text == '90') {
      args.text = 'E';
    } else if (args.text == '180') {
      args.text = 'S';
    } else if (args.text == '270') {
      args.text = 'W';
    }else{
      args.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('wind-compass'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          animateNeedle();
        }
      },
      child: AnimatedBuilder(
        animation: _needleAnimation,
        builder: (context, child) {
          return SizedBox(
            width: 160,
            height: 200,
              child:
              /// Wind compass02
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background red circle behind the gauge
                  Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),

                  // The actual gauge on top of the red background
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      // Main axis (with needle)
                      RadialAxis(
                        showAxisLine: false,
                        radiusFactor: 1.30,
                        canRotateLabels: false,
                        tickOffset: 0.32,
                        offsetUnit: GaugeSizeUnit.factor,
                        onLabelCreated: _handleAxisLabelCreated,
                        startAngle: 270,
                        endAngle: 270,
                        labelOffset: 0.05,
                        maximum: 360,
                        interval: 30,
                        minorTicksPerInterval: 1,
                        axisLineStyle: AxisLineStyle(
                          thickness: 2,
                        ),
                        axisLabelStyle: GaugeTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        minorTickStyle: MinorTickStyle(
                          color: Colors.white60,
                          thickness: 1.6,
                          length: 0.058,
                          lengthUnit: GaugeSizeUnit.factor,
                        ),
                        majorTickStyle: const MajorTickStyle(
                          color: Colors.white,
                          thickness: 2,
                          length: 0.1,
                          lengthUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: _needleAnimation.value,
                            needleLength: 0.6,
                            needleStartWidth: 0,
                            needleEndWidth: 5,
                            needleColor: Colors.white,
                            knobStyle: const KnobStyle(
                              knobRadius: 0.045,
                              color: Colors.white,
                              borderWidth: 1,
                            ),
                          ),
                        ],
                      ),

                      // Inner ring axis with blue circle
                      RadialAxis(
                        showTicks: false,
                        showLabels: false,
                        startAngle: 270,
                        endAngle: 270,
                        radiusFactor: 0.4,
                        axisLineStyle: AxisLineStyle(
                          thicknessUnit: GaugeSizeUnit.factor,
                          color: Colors.blue.shade400,
                        ),
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            angle: 90,
                            positionFactor: 0.1,
                            widget: Text(
                              '90 mps',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          );

          /// Wind compass01
            SfRadialGauge(
            axes: [
              RadialAxis(
                minimum: 0,
                maximum: 360,
                showTicks: false,
                showLabels: false,
                startAngle: 270,
                endAngle: 630,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.1,
                  color: Colors.transparent,
                ),
                pointers: [
                  NeedlePointer(
                    value: _needleAnimation.value,
                    enableAnimation: false,
                    needleColor: Colors.white,
                    needleLength: 0.95, // REACHES OUTER RING
                    needleStartWidth: 0,
                    needleEndWidth: 8,
                    knobStyle: KnobStyle(
                      knobRadius: 0.50,
                      color: Colors.blue.shade300,
                      borderWidth: 1,
                    ),
                  ),
                ],
                annotations: const [
                  GaugeAnnotation(
                    angle: 270,
                    positionFactor: 0.9,
                    widget: Text('N',
                        style:
                        TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  GaugeAnnotation(
                    angle: 0,
                    positionFactor: 0.9,
                    widget: Text('E',
                        style:
                        TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  GaugeAnnotation(
                    angle: 90,
                    positionFactor: 0.9,
                    widget: Text('S',
                        style:
                        TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  GaugeAnnotation(
                    angle: 180,
                    positionFactor: 0.9,
                    widget: Text('W',
                        style:
                        TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
