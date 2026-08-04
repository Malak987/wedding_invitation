import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/config_manager.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
    // sigma 10 keeps the frosted look at ~40% of the old blur cost —
    // backdrop blur is the most expensive paint op on Flutter web, and
    // these cards sit over scrolling content, so it re-runs every frame.
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final primary = manager.primaryColor;

    // RepaintBoundary isolates each card so a repaint in one card never
    // forces siblings (or the scrolling backdrop) to re-rasterize.
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.45),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: primary.withOpacity(0.25), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
