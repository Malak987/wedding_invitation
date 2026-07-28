import 'package:flutter/material.dart';

/// Wraps [child] with an endless subtle up/down float — great for
/// flower/ring decorations. Cheap: single repeating tween, no rebuilds
/// outside this widget's subtree.
class FloatingWidget extends StatefulWidget {
  final Widget child;
  final double range;
  final Duration duration;

  const FloatingWidget({
    super.key,
    required this.child,
    this.range = 10,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: -widget.range, end: widget.range)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _animation.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}
