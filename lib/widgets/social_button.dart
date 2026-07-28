import 'package:flutter/material.dart';
import '../dashboard/colors.dart';
import '../core/constants.dart';

class SocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SocialButton({super.key, required this.icon, required this.onTap});

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovering ? AppColorsData.primary : AppColorsData.accent,
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _hovering ? Colors.white : AppColorsData.secondary,
          ),
        ),
      ),
    );
  }
}
