import 'package:flutter/material.dart';
import '../dashboard/strings.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../models/schedule_item.dart';
import '../widgets/section_title.dart';
import '../widgets/schedule_card.dart';
import '../animations/slide_in.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

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
          const SectionTitle(title: AppStrings.scheduleTitle),
          const SizedBox(height: 36),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: List.generate(defaultSchedule.length, (index) {
                final isLast = index == defaultSchedule.length - 1;
                return SlideIn(
                  direction: SlideDirection.right,
                  delay: Duration(milliseconds: 120 * index),
                  child: ScheduleCard(item: defaultSchedule[index], isLast: isLast),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
