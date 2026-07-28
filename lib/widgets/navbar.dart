import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
import '../core/responsive.dart';

class FloatingNavbar extends StatelessWidget {
  final VoidCallback onScrollToStory;
  final VoidCallback onScrollToCountdown;
  final VoidCallback onScrollToGallery;
  final VoidCallback onScrollToVenue;
  final VoidCallback onScrollToRsvp;

  const FloatingNavbar({
    super.key,
    required this.onScrollToStory,
    required this.onScrollToCountdown,
    required this.onScrollToGallery,
    required this.onScrollToVenue,
    required this.onScrollToRsvp,
  });

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final primary = manager.primaryColor;
    final isDesktop = Responsive.isDesktop(context);

    // Dynamic Monogram Logo
    final monogram = '${manager.groomName.substring(0, 1)} & ${manager.brideName.substring(0, 1)}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Monogram / Logo
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Scroll to top
                Scrollable.ensureVisible(
                  context,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                );
              },
              child: Text(
                monogram,
                style: TextStyle(
                  fontFamily: manager.headingFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          // Center: Navigation links (only for desktop/tablet)
          if (isDesktop)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (manager.showStory)
                  _buildNavLink(Localization.get(lang, 'nav_story'), onScrollToStory, manager),
                if (manager.showCountdown)
                  _buildNavLink(Localization.get(lang, 'nav_countdown'), onScrollToCountdown, manager),
                if (manager.showGallery)
                  _buildNavLink(Localization.get(lang, 'nav_gallery'), onScrollToGallery, manager),
                if (manager.showLocation)
                  _buildNavLink(Localization.get(lang, 'nav_location'), onScrollToVenue, manager),
                if (manager.showRsvp)
                  _buildNavLink(Localization.get(lang, 'nav_rsvp'), onScrollToRsvp, manager),
              ],
            ),

          // Right: Lang Switcher
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Language Switch Button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    final nextLang = lang == 'ar' ? 'en' : 'ar';
                    manager.setLanguage(nextLang);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primary.withOpacity(0.5), width: 1),
                    ),
                    child: Text(
                      lang == 'ar' ? 'EN' : 'العربية',
                      style: TextStyle(
                        fontFamily: manager.bodyFont,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: manager.secondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String label, VoidCallback onTap, AppConfigManager manager) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: manager.bodyFont,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
