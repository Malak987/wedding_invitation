import 'package:flutter/material.dart';
import '../theme/text_styles.dart';
import 'custom_divider.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.sectionTitle, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const CustomDivider(),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: AppTextStyles.sectionSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
