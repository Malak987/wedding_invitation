import 'dart:ui';
import 'package:flutter/material.dart';
import '../dashboard/colors.dart';
import '../core/constants.dart';

/// Frosted-glass container used for countdown items, schedule cards,
/// gift card, etc. Stateless & const-friendly for performance.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = AppConstants.borderRadiusMedium,
    this.blur = AppConstants.blurSigma,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColorsData.glassFill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColorsData.glassBorder, width: 1.2),
          ),
          child: child,
        ),
      ),
    );
  }
}
