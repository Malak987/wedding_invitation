import 'package:flutter/material.dart';
import '../dashboard/invitation_data.dart';
import '../dashboard/links.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../theme/text_styles.dart';
import '../utils/launch_url.dart';
import '../widgets/section_title.dart';
import '../widgets/animated_button.dart';
import '../animations/fade_in.dart';

class RsvpSection extends StatelessWidget {
  const RsvpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsData.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(context,
            mobile: AppConstants.sectionSpacingMobile, desktop: AppConstants.sectionSpacing),
      ),
      child: Column(
        children: [
          SectionTitle(title: InvitationData.rsvpTitle),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              InvitationData.rsvpDescription,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),
          FadeIn(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                AnimatedButton(
                  label: 'تأكيد عبر واتساب',
                  icon: Icons.chat_outlined,
                  onPressed: () => launchAppUrl(AppLinks.whatsapp),
                ),
                AnimatedButton(
                  label: 'اتصال',
                  icon: Icons.call_outlined,
                  backgroundColor: AppColorsData.secondary,
                  onPressed: () => launchPhoneCall(InvitationData.phoneNumber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
