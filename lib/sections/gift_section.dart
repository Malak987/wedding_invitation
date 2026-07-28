import 'package:flutter/material.dart';
import '../dashboard/strings.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../theme/text_styles.dart';
import '../widgets/section_title.dart';
import '../widgets/glass_card.dart';
import '../animations/scale_in.dart';

class GiftSection extends StatelessWidget {
  const GiftSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsData.accent.withOpacity(0.15),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(context,
            mobile: AppConstants.sectionSpacingMobile, desktop: AppConstants.sectionSpacing),
      ),
      child: Column(
        children: [
          const SectionTitle(title: AppStrings.giftTitle),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ScaleIn(
              child: GlassCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    Icon(Icons.card_giftcard_outlined, color: AppColorsData.primary, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      'حضوركم هو أغلى هدية، ومن أراد المشاركة يمكنه التواصل معنا مباشرة.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
