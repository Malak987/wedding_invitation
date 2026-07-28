import 'package:flutter/material.dart';
import '../services/config_manager.dart';

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
    final manager = AppConfigManager.instance;
    final primary = manager.primaryColor;
    final secondary = manager.secondaryColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovering ? primary : primary.withOpacity(0.12),
            border: Border.all(color: primary, width: 1),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _hovering ? Colors.white : secondary,
          ),
        ),
      ),
    );
  }
}
