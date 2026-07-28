import 'package:flutter/material.dart';
import '../dashboard/invitation_data.dart';
import '../dashboard/links.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../utils/launch_url.dart';
import '../widgets/section_title.dart';
import '../widgets/location_card.dart';
import '../animations/fade_in.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

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
          const SectionTitle(title: 'مكان الحفل'),
          const SizedBox(height: 36),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: FadeIn(
              child: LocationCard(
                venueName: InvitationData.venueName,
                address: InvitationData.venueAddress,
                dateText: InvitationData.eventDate,
                timeText: InvitationData.eventTime,
                onGetDirections: () => launchAppUrl(AppLinks.googleMaps),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
