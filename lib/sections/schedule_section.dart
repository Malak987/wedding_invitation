import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../widgets/section_title.dart';
import '../widgets/schedule_card.dart';
import '../animations/slide_in.dart';
import '../models/schedule_item.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  List<ScheduleItem> _getLocalizedSchedule(String langCode) {
    if (langCode == 'en') {
      return [
        const ScheduleItem(time: '6:30 PM', title: 'Guest Reception', icon: Icons.local_florist_outlined),
        const ScheduleItem(time: '7:00 PM', title: 'Grand Entrance', icon: Icons.favorite_border),
        const ScheduleItem(time: '8:00 PM', title: 'Celebration Dinner', icon: Icons.restaurant_outlined),
        const ScheduleItem(time: '9:30 PM', title: 'Cake Cutting Ceremony', icon: Icons.cake_outlined),
      ];
    }
    // Arabic
    return [
      const ScheduleItem(time: '6:30 م', title: 'استقبال الضيوف', icon: Icons.local_florist_outlined),
      const ScheduleItem(time: '7:00 م', title: 'دخول العروسين', icon: Icons.favorite_border),
      const ScheduleItem(time: '8:00 م', title: 'مأدبة العشاء', icon: Icons.restaurant_outlined),
      const ScheduleItem(time: '9:30 م', title: 'قطع الكعكة الحفل', icon: Icons.cake_outlined),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final schedule = _getLocalizedSchedule(lang);

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
                title: Localization.get(lang, 'schedule_title'),
                subtitle: Localization.get(lang, 'welcome_subtitle'),
              ),
              const SizedBox(height: 48),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: List.generate(schedule.length, (index) {
                    final isLast = index == schedule.length - 1;
                    return SlideIn(
                      direction: SlideDirection.right,
                      delay: Duration(milliseconds: 100 * index),
                      child: ScheduleCard(item: schedule[index], isLast: isLast),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
