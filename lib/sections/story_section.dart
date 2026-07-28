import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../widgets/section_title.dart';
import '../widgets/photo_card.dart';
import '../animations/fade_in.dart';
import '../animations/slide_in.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final isDesktop = Responsive.isDesktop(context);

    // Standard high-quality imagery from existing asset index
    const String coupleImg1 = 'assets/images/2.jpg';
    const String coupleImg2 = 'assets/images/3.jpg';

    final textColumn = FadeIn(
      child: Column(
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.spa_outlined,
            color: manager.primaryColor,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            manager.storyText,
            style: TextStyle(
              fontFamily: manager.bodyFont,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.8,
            ),
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Subtle romantic sign-off
          Text(
            "— ${manager.groomName} & ${manager.brideName}",
            style: TextStyle(
              fontFamily: manager.headingFont,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: manager.primaryColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );

    final photosRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SlideIn(
            direction: SlideDirection.left,
            child: const PhotoCard(imagePath: coupleImg1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SlideIn(
            direction: SlideDirection.right,
            delay: const Duration(milliseconds: 150),
            child: const PhotoCard(imagePath: coupleImg2),
          ),
        ),
      ],
    );

    return Container(
      color: manager.accentColor,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(
          context,
          mobile: AppConstants.sectionSpacingMobile,
          desktop: AppConstants.sectionSpacing,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            children: [
              SectionTitle(
                title: Localization.get(lang, 'story_title'),
                subtitle: Localization.get(lang, 'welcome_subtitle'),
              ),
              const SizedBox(height: 48),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: photosRow),
                    const SizedBox(width: 64),
                    Expanded(child: textColumn),
                  ],
                )
              else
                Column(
                  children: [
                    photosRow,
                    const SizedBox(height: 36),
                    textColumn,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
