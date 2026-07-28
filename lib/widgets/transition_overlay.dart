import 'package:flutter/material.dart';

class TransitionOverlay extends StatelessWidget {
  final bool isTransitioning;
  final Duration duration;

  const TransitionOverlay({
    super.key,
    required this.isTransitioning,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: isTransitioning ? 1.0 : 0.0,
          duration: duration,
          curve: Curves.easeInOutCubic,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white,
                  Color(0xFFFFFDF9), // Luxury Warm White
                ],
                radius: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
