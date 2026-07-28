import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../widgets/custom_divider.dart';
import '../animations/fade_in.dart';

class ThankYouSection extends StatelessWidget {
  const ThankYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final textOnDark = Colors.white;

    return Container(
      width: double.infinity,
      color: manager.secondaryColor,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(
          context,
          mobile: AppConstants.sectionSpacingMobile,
          desktop: AppConstants.sectionSpacing,
        ),
      ),
      child: FadeIn(
        child: Column(
          children: [
            Text(
              Localization.get(lang, 'thank_you_title'),
              style: TextStyle(
                fontFamily: manager.headingFont,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: manager.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const CustomDivider(),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Text(
                Localization.get(lang, 'thank_you_desc'),
                style: TextStyle(
                  fontFamily: manager.bodyFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: textOnDark.withOpacity(0.9),
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
