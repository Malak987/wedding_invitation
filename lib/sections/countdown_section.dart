import 'package:flutter/material.dart';
import '../dashboard/invitation_data.dart';
import '../dashboard/countdown.dart';
import '../dashboard/strings.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../theme/text_styles.dart';
import '../utils/countdown_timer.dart';
import '../widgets/countdown_item.dart';
import '../widgets/section_title.dart';
import '../animations/fade_in.dart';

class CountdownSection extends StatefulWidget {
  const CountdownSection({super.key});

  @override
  State<CountdownSection> createState() => _CountdownSectionState();
}

class _CountdownSectionState extends State<CountdownSection> {
  late final CountdownTimer _timer;

  @override
  void initState() {
    super.initState();
    _timer = CountdownTimer(DateTime.parse(AppCountdown.targetDateIso));
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColorsData.accent.withOpacity(0.15),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(context,
            mobile: AppConstants.sectionSpacingMobile, desktop: AppConstants.sectionSpacing),
      ),
      child: Column(
        children: [
          SectionTitle(
            title: 'العد التنازلي',
            subtitle: '${InvitationData.eventDayName} • ${InvitationData.eventDate}',
          ),
          const SizedBox(height: 36),
          FadeIn(
            delay: const Duration(milliseconds: 200),
            child: ValueListenableBuilder<CountdownValue>(
              valueListenable: _timer.value,
              builder: (context, value, _) {
                if (value.finished) {
                  return Text(AppCountdown.finishedMessage, style: AppTextStyles.sectionTitle);
                }
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    CountdownItemWidget(value: value.days, label: AppStrings.countdownDays),
                    CountdownItemWidget(value: value.hours, label: AppStrings.countdownHours),
                    CountdownItemWidget(value: value.minutes, label: AppStrings.countdownMinutes),
                    CountdownItemWidget(value: value.seconds, label: AppStrings.countdownSeconds),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
