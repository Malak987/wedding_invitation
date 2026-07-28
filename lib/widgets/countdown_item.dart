import 'package:flutter/material.dart';
import '../theme/text_styles.dart';
import 'glass_card.dart';

/// Displays a single countdown number (e.g. days) + label.
/// Kept as its own widget so only this piece rebuilds when its
/// [value] changes, not the whole countdown row.
class CountdownItemWidget extends StatelessWidget {
  final int value;
  final String label;

  const CountdownItemWidget({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: AppTextStyles.countdownNumber,
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.countdownLabel),
        ],
      ),
    );
  }
}
