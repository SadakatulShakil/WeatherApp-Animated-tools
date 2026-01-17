import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedTempIndicator extends StatefulWidget {
  // Pass the calculated difference: (max - min).abs()
  final double rangeDiff;
  final double maxRangeScale;

  const AnimatedTempIndicator({
    Key? key,
    required this.rangeDiff,
    this.maxRangeScale = 15.0, // Adjust this based on your data needs
  }) : super(key: key);

  @override
  State<AnimatedTempIndicator> createState() => _AnimatedTempIndicatorState();
}

class _AnimatedTempIndicatorState extends State<AnimatedTempIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Standard ease out curve for smooth growth
    _curveAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _startAnimation() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate final width percentage (0.0 to 1.0)
    // e.g., if difference is 7 and scale is 15, width is 46%
    final double targetWidthFactor = (widget.rangeDiff / widget.maxRangeScale).clamp(0.0, 1.0);

    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_hasAnimated) {
          _hasAnimated = true;
          _startAnimation();
        }
      },
      child: Container(
        height: 8,
        // Optional: Add a background color if you want a "track"
        // color: Colors.grey.withOpacity(0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerLeft, // Ensures it starts from min (Left)
        child: AnimatedBuilder(
          animation: _curveAnimation,
          builder: (context, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              // We multiply the animation value (0 to 1) by your target width
              widthFactor: _curveAnimation.value * targetWidthFactor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}