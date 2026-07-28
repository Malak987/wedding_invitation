import 'package:flutter/material.dart';
import '../dashboard/colors.dart';

class CustomDivider extends StatelessWidget {
  final double width;

  const CustomDivider({super.key, this.width = 60});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 2, color: AppColorsData.divider),
        const SizedBox(width: 8),
        Icon(Icons.favorite, size: 14, color: AppColorsData.primary),
        const SizedBox(width: 8),
        Container(width: 16, height: 2, color: AppColorsData.divider),
      ],
    );
  }
}
