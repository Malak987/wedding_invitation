import 'dart:math';
import 'package:flutter/material.dart';
import '../dashboard/colors.dart';

/// A cheap, dependency-free decorative particle field (small dots
/// gently drifting upward). Painted with CustomPainter and a single
/// AnimationController — safe for background use behind sections.
class BackgroundParticles extends StatefulWidget {
  final int particleCount;

  const BackgroundParticles({super.key, this.particleCount = 24});

  @override
  State<BackgroundParticles> createState() => _BackgroundParticlesState();
}

class _Particle {
  double x;
  double y;
  double radius;
  double speed;

  _Particle({required this.x, required this.y, required this.radius, required this.speed});
}

class _BackgroundParticlesState extends State<BackgroundParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 2.5 + 1.5,
        speed: _random.nextDouble() * 0.15 + 0.05,
      ));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ParticlePainter(_particles, _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColorsData.primary.withOpacity(0.25);
    for (final p in particles) {
      final dy = (p.y - progress * p.speed) % 1.0;
      final offset = Offset(p.x * size.width, dy * size.height);
      canvas.drawCircle(offset, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
