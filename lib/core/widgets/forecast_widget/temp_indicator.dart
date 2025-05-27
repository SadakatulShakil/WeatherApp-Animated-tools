import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedTempIndicator extends StatefulWidget {
  final double rangeFactor;

  const AnimatedTempIndicator({Key? key, required this.rangeFactor})
      : super(key: key);

  @override
  State<AnimatedTempIndicator> createState() => _AnimatedTempIndicatorState();
}

class _AnimatedTempIndicatorState extends State<AnimatedTempIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Dummy initialization to avoid LateInitializationError
    _position = AlwaysStoppedAnimation(widget.rangeFactor);
  }

  void _startAnimation() {
    _position = Tween<double>(begin: 0, end: widget.rangeFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_hasAnimated) {
          _hasAnimated = true;
          _startAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final widthFactor = (_position.value / 15.0).clamp(0.0, 1.0);

          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: widthFactor,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
