import 'package:flutter/material.dart';
import 'dashboard/app_config.dart';
import 'theme/app_theme.dart';
import 'sections/hero_section.dart';
import 'sections/story_section.dart';
import 'sections/countdown_section.dart';
import 'sections/gallery_section.dart';
import 'sections/location_section.dart';
import 'sections/schedule_section.dart';
import 'sections/gift_section.dart';
import 'sections/rsvp_section.dart';
import 'sections/thank_you_section.dart';
import 'sections/footer_section.dart';
import 'sections/music_player.dart';

void main() {
  runApp(const EngagementInvitationApp());
}

class EngagementInvitationApp extends StatelessWidget {
  const EngagementInvitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // RTL for Arabic content by default.
      locale: const Locale('ar'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const InvitationHomePage(),
    );
  }
}

class InvitationHomePage extends StatefulWidget {
  const InvitationHomePage({super.key});

  @override
  State<InvitationHomePage> createState() => _InvitationHomePageState();
}

class _InvitationHomePageState extends State<InvitationHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _rsvpKey = GlobalKey();

  void _scrollToRsvp() {
    final ctx = _rsvpKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: AppConfig.enableSmoothScroll
                ? const BouncingScrollPhysics()
                : const ClampingScrollPhysics(),
            child: Column(
              children: [
                HeroSection(onScrollToRsvp: _scrollToRsvp),
                if (AppConfig.showStorySection) const StorySection(),
                if (AppConfig.showCountdownSection) const CountdownSection(),
                if (AppConfig.showGallerySection) const GallerySection(),
                if (AppConfig.showLocationSection) const LocationSection(),
                if (AppConfig.showScheduleSection) const ScheduleSection(),
                if (AppConfig.showGiftSection) const GiftSection(),
                if (AppConfig.showRsvpSection)
                  KeyedSubtree(key: _rsvpKey, child: const RsvpSection()),
                const ThankYouSection(),
                const FooterSection(),
              ],
            ),
          ),
          if (AppConfig.showMusicPlayer) const MusicPlayerWidget(),
        ],
      ),
    );
  }
}
