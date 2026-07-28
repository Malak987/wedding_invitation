import 'package:flutter/material.dart';
import '../dashboard/colors.dart';
import '../theme/text_styles.dart';
import '../models/schedule_item.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleItem item;
  final bool isLast;

  const ScheduleCard({super.key, required this.item, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColorsData.accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(item.icon, size: 20, color: AppColorsData.secondary),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColorsData.divider),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.time, style: AppTextStyles.body.copyWith(
                      color: AppColorsData.primary, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(item.title, style: AppTextStyles.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
