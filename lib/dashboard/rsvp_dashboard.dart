import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants.dart';
import '../core/responsive.dart';
import '../cubit/rsvp_stats_cubit.dart';
import '../cubit/rsvp_stats_state.dart';
import '../services/config_manager.dart';
import '../widgets/section_title.dart';

/// Admin/owner RSVP dashboard.
///
/// Reads every statistic from [RsvpStatsCubit], which computes them
/// dynamically from the normalized `guestResponses` collection via a single
/// realtime Firestore snapshot. Nothing here is read from a stored aggregate
/// document, so it always reflects the live guest data.
class RsvpDashboardSection extends StatelessWidget {
  const RsvpDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final isAr = manager.selectedLanguage == 'ar';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            manager.accentColor,
            Color.lerp(manager.accentColor, manager.primaryColor, 0.08)!,
          ],
        ),
      ),
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
          constraints: BoxConstraints(
            maxWidth: Responsive.maxContentWidth(context),
          ),
          child: Column(
            children: [
              SectionTitle(
                title: isAr ? 'لوحة الحضور' : 'Attendance Dashboard',
                subtitle: isAr
                    ? 'إحصائيات لحظية محسوبة مباشرة من ردود الضيوف'
                    : 'Live statistics computed directly from guest responses',
              ),
              const SizedBox(height: 24),
              BlocBuilder<RsvpStatsCubit, RsvpStatsState>(
                builder: (context, state) {
                  if (state.loading) {
                    return _StatusPill(
                      isAr: isAr,
                      text: isAr ? 'جارٍ التحميل…' : 'Loading…',
                      child: const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  if (state.error == 'permission-denied') {
                    return _StatusPill(
                      isAr: isAr,
                      text: isAr
                          ? 'لا تملك صلاحية عرض لوحة الحضور. سجّل الدخول كمسؤول.'
                          : 'You need admin access to view the dashboard.',
                    );
                  }
                  if (state.error != null) {
                    return _StatusPill(
                      isAr: isAr,
                      text: isAr
                          ? 'تعذّر تحميل البيانات. تحقق من الاتصال.'
                          : 'Could not load statistics. Check your connection.',
                    );
                  }

                  return _StatsGrid(isAr: isAr, state: state);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isAr;
  final String text;
  final Widget? child;

  const _StatusPill({required this.isAr, required this.text, this.child});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: manager.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null) ...[child!, const SizedBox(width: 10)],
          Text(
            text,
            style: TextStyle(
              fontFamily: manager.bodyFont,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: manager.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final bool isAr;
  final RsvpStatsState state;

  const _StatsGrid({required this.isAr, required this.state});

  @override
  Widget build(BuildContext context) {
    final metrics = <_Metric>[
      _Metric(
        label: isAr ? 'إجمالي الدعوات' : 'Total Invitations',
        value: '${state.totalInvitations}',
        icon: Icons.mark_email_read_rounded,
        accent: AppConfigManager.instance.primaryColor,
      ),
      _Metric(
        label: isAr ? 'تأكيد الحضور' : 'Confirmed',
        value: '${state.confirmedGuests}',
        icon: Icons.check_circle_rounded,
        accent: const Color(0xFF3E6B4F),
      ),
      _Metric(
        label: isAr ? 'المعتذون' : 'Declined',
        value: '${state.declinedGuests}',
        icon: Icons.cancel_rounded,
        accent: const Color(0xFF9A3B2B),
      ),
      _Metric(
        label: isAr ? 'بانتظار الرد' : 'Pending',
        value: '${state.pendingGuests}',
        icon: Icons.hourglass_top_rounded,
        accent: const Color(0xFFB07A2B),
      ),
      _Metric(
        label: isAr ? 'إجمالي الحاضرين' : 'Total Attendees',
        value: '${state.totalAttendees}',
        icon: Icons.groups_rounded,
        accent: AppConfigManager.instance.secondaryColor,
      ),
      _Metric(
        label: isAr ? 'متوسط الأفراد/الدعوة' : 'Avg Guests / Invite',
        value: state.averageGuestsPerInvitation.toStringAsFixed(2),
        icon: Icons.people_alt_rounded,
        accent: AppConfigManager.instance.primaryColor,
      ),
    ];

    final isMobile = Responsive.isMobile(context);
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 16,
      spacing: 16,
      children: metrics
          .map((m) => SizedBox(
                width: isMobile ? double.infinity : 240,
                child: _StatCard(metric: m),
              ))
          .toList(),
    );
  }
}

class _Metric {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _Metric({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });
}

class _StatCard extends StatelessWidget {
  final _Metric metric;

  const _StatCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.92),
                Colors.white.withOpacity(0.74),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: metric.accent.withOpacity(0.35), width: 1),
            boxShadow: [
              BoxShadow(
                color: metric.accent.withOpacity(0.14),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: metric.accent.withOpacity(0.12),
                  border: Border.all(color: metric.accent.withOpacity(0.5)),
                ),
                child: Icon(metric.icon, color: metric.accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.value,
                      style: TextStyle(
                        fontFamily: manager.headingFont,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: manager.secondaryColor,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      metric.label,
                      style: TextStyle(
                        fontFamily: manager.bodyFont,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: manager.secondaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
