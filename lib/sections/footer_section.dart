import 'package:flutter/material.dart';
import '../dashboard/invitation_data.dart';
import '../dashboard/links.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../theme/text_styles.dart';
import '../utils/launch_url.dart';
import '../widgets/social_button.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColorsData.backgroundDark,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 32,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(icon: Icons.camera_alt_outlined, onTap: () => launchAppUrl(AppLinks.instagram)),
              const SizedBox(width: 14),
              SocialButton(icon: Icons.facebook_outlined, onTap: () => launchAppUrl(AppLinks.facebook)),
              const SizedBox(width: 14),
              SocialButton(icon: Icons.chat_bubble_outline, onTap: () => launchAppUrl(AppLinks.whatsapp)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            InvitationData.footerText,
            style: AppTextStyles.body.copyWith(color: AppColorsData.textOnDark.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
