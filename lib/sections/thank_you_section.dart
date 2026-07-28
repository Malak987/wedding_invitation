import 'package:flutter/material.dart';
import '../dashboard/invitation_data.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../theme/text_styles.dart';
import '../widgets/custom_divider.dart';
import '../animations/fade_in.dart';

class ThankYouSection extends StatelessWidget {
  const ThankYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColorsData.secondary,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(context,
            mobile: AppConstants.sectionSpacingMobile, desktop: AppConstants.sectionSpacing),
      ),
      child: FadeIn(
        child: Column(
          children: [
            Text(
              InvitationData.thankYouTitle,
              style: AppTextStyles.sectionTitle.copyWith(color: AppColorsData.textOnDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const CustomDivider(),
            const SizedBox(height: 16),
            Text(
              InvitationData.thankYouMessage,
              style: AppTextStyles.sectionSubtitle.copyWith(color: AppColorsData.textOnDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
