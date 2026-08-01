import 'dart:ui';
import 'package:flutter/material.dart';

/// Small floating glass instruction card shown above the wax seal before the
/// invitation is opened. Fades + gently floats in, then disappears the
/// instant the seal is tapped (handled by the parent via [visible]).
class InstructionWidget extends StatefulWidget {
  final bool isReady;
  final bool visible;

  const InstructionWidget({
    super.key,
    this.isReady = true,
    this.visible = true,
  });

  @override
  State<InstructionWidget> createState() => _InstructionWidgetState();
}

class _InstructionWidgetState extends State<InstructionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    // Very gentle continuous float — a few pixels, slow, never distracting.
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);
    const darkGreen = Color(0xFF2b100a);

    // While assets are still preloading, show a minimal, honest "preparing"
    // state instead of an instruction that would not respond to a tap yet.
    if (!widget.isReady) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: widget.visible ? 1 : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(goldColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'جاري التحضير...',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: goldColor.withOpacity(0.65),
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return AnimatedOpacity(
      // 150ms fade-out on tap, gentle fade-in otherwise.
      duration: Duration(milliseconds: widget.visible ? 500 : 150),
      curve: Curves.easeOut,
      opacity: widget.visible ? 1 : 0,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final dy = -3.0 + (_floatController.value * 6.0); // gentle float, -3..+3 px
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: darkGreen.withOpacity(0.85),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: goldColor.withOpacity(0.55), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اضغط على الختم لفتح الدعوة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: goldColor,
                      letterSpacing: 0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tap the wax seal to begin',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w300,
                      color: goldColor.withOpacity(0.7),
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}