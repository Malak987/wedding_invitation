import 'package:flutter/material.dart';
import '../dashboard/colors.dart';
import '../dashboard/strings.dart';
import '../theme/text_styles.dart';
import 'glass_card.dart';
import 'animated_button.dart';

class LocationCard extends StatelessWidget {
  final String venueName;
  final String address;
  final String dateText;
  final String timeText;
  final VoidCallback onGetDirections;

  const LocationCard({
    super.key,
    required this.venueName,
    required this.address,
    required this.dateText,
    required this.timeText,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(Icons.location_on_outlined, color: AppColorsData.primary, size: 36),
          const SizedBox(height: 12),
          Text(venueName, style: AppTextStyles.sectionSubtitle.copyWith(
              fontWeight: FontWeight.w700, color: AppColorsData.textPrimary)),
          const SizedBox(height: 6),
          Text(address, style: AppTextStyles.body, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text('$dateText — $timeText', style: AppTextStyles.body),
          const SizedBox(height: 20),
          AnimatedButton(
            label: AppStrings.btnGetDirections,
            icon: Icons.directions_outlined,
            onPressed: onGetDirections,
          ),
        ],
      ),
    );
  }
}
