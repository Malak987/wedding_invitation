import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
import '../core/responsive.dart';
import '../utils/launch_url.dart';
import '../widgets/social_button.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final textOnDark = Colors.white;

    return Container(
      width: double.infinity,
      color: Colors.black, // Sleek black base
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(
                icon: Icons.camera_alt_outlined,
                onTap: () => launchAppUrl(manager.instagramUrl),
              ),
              const SizedBox(width: 16),
              SocialButton(
                icon: Icons.facebook_outlined,
                onTap: () => launchAppUrl(manager.facebookUrl),
              ),
              const SizedBox(width: 16),
              SocialButton(
                icon: Icons.chat_bubble_outline_sharp,
                onTap: () => launchAppUrl('https://wa.me/${manager.whatsappNumber}'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            Localization.get(lang, 'footer_text'),
            style: TextStyle(
              fontFamily: manager.bodyFont,
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: textOnDark.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
