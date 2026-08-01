import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Invisible-but-alive tap zone anchored where the wax seal appears in the
/// intro video. The seal graphic itself lives inside the video (baked-in
/// pixels), so this widget never draws a hard-edged circle — only a soft,
/// blurred ambient glow/pulse/shine that reads as "this is alive, tap me"
/// without needing to match the video's seal pixel-for-pixel.
///
/// If the glow doesn't sit exactly on your seal, adjust [size] or wrap this
/// widget with an extra `Transform.translate` / different `Alignment` where
/// it's used in `LandingScreen`.
class SealHotspot extends StatefulWidget {
  final bool enabled;
  final double size;
  final VoidCallback onTap;

  const SealHotspot({
    super.key,
    required this.enabled,
    required this.onTap,
    this.size = 130,
  });

  @override
  State<SealHotspot> createState() => _SealHotspotState();
}

class _SealHotspotState extends State<SealHotspot> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;
  late final AnimationController _rippleController;

  bool _isHovered = false;
  bool _tapped = false;

  static const _gold = Color(0xFFD4AF37);
  static const _emberRed = Color(0xFF8A1412);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant SealHotspot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && oldWidget.enabled) {
      _pulseController.stop();
      _shimmerController.stop();
    } else if (widget.enabled && !oldWidget.enabled) {
      _pulseController.repeat();
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled || _tapped) return;

    setState(() => _tapped = true);

    // Stop every idle/onboarding animation immediately.
    _pulseController.stop();
    _shimmerController.stop();
    _rippleController.forward(from: 0);

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final hoverScale = (_isHovered && widget.enabled && !_tapped) ? 1.04 : 1.0;

    return MouseRegion(
      cursor: widget.enabled && !_tapped
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (widget.enabled && !_tapped) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (widget.enabled && !_tapped) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: AnimatedScale(
          scale: hoverScale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Soft subtle red ember glow, breathing slowly.
                if (widget.enabled && !_tapped)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final t = (math.sin(_pulseController.value * 2 * math.pi) + 1) / 2;
                      final opacity = 0.10 + (t * 0.14);
                      final scale = 0.9 + (t * 0.12);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _emberRed.withOpacity(opacity),
                                blurRadius: widget.size * 0.45,
                                spreadRadius: widget.size * 0.05,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                // Slow gold shine sweeping across the seal area.
                if (widget.enabled && !_tapped)
                  ClipOval(
                    child: SizedBox(
                      width: widget.size * 0.72,
                      height: widget.size * 0.72,
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          final val = _shimmerController.value;
                          return Opacity(
                            opacity: 0.55,
                            child: FractionalTranslation(
                              translation: Offset(val * 2.6 - 1.3, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _gold.withOpacity(0.0),
                                      _gold.withOpacity(0.22),
                                      _gold.withOpacity(0.0),
                                    ],
                                    stops: const [0.35, 0.5, 0.65],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                // Short gold ripple flash on tap.
                if (_tapped)
                  AnimatedBuilder(
                    animation: _rippleController,
                    builder: (context, child) {
                      final progress = _rippleController.value;
                      final scale = 0.6 + (progress * 0.9);
                      final opacity = (1 - progress).clamp(0.0, 1.0) * 0.5;
                      return Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: widget.size,
                            height: widget.size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: _gold, width: 2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}