import 'package:flutter/material.dart';
import '../dashboard/invitation_data.dart';
import '../dashboard/images.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../theme/text_styles.dart';
import '../widgets/section_title.dart';
import '../widgets/photo_card.dart';
import '../animations/fade_in.dart';
import '../animations/slide_in.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    final textColumn = FadeIn(
      child: Column(
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            InvitationData.storyText,
            style: AppTextStyles.body,
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
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
            child: PhotoCard(imagePath: AppImages.coupleImage1),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SlideIn(
            direction: SlideDirection.right,
            delay: const Duration(milliseconds: 150),
            child: PhotoCard(imagePath: AppImages.coupleImage2),
          ),
        ),
      ],
    );

    return Container(
      color: AppColorsData.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(context,
            mobile: AppConstants.sectionSpacingMobile, desktop: AppConstants.sectionSpacing),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            children: [
              SectionTitle(title: InvitationData.storyTitle),
              const SizedBox(height: 40),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: photosRow),
                    const SizedBox(width: 48),
                    Expanded(child: textColumn),
                  ],
                )
              else
                Column(
                  children: [
                    photosRow,
                    const SizedBox(height: 28),
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
