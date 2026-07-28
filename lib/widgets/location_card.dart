import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
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
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final primary = manager.primaryColor;
    final secondary = manager.secondaryColor;

    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.location_on_outlined, color: primary, size: 40),
          const SizedBox(height: 16),
          Text(
            venueName,
            style: TextStyle(
              fontFamily: manager.headingFont,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: secondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: TextStyle(
              fontFamily: manager.bodyFont,
              fontSize: 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '$dateText — $timeText',
            style: TextStyle(
              fontFamily: manager.bodyFont,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 28),
          AnimatedButton(
            label: Localization.get(lang, 'btn_directions'),
            icon: Icons.directions_outlined,
            onPressed: onGetDirections,
          ),
        ],
      ),
    );
  }
}
