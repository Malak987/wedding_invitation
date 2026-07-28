import 'package:flutter/material.dart';
import 'services/config_manager.dart';
import 'services/audio_service.dart';
import 'widgets/landing_screen.dart';
import 'widgets/transition_overlay.dart';
import 'widgets/navbar.dart';
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
import 'sections/guest_gallery_section.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EngagementInvitationApp());
}

class EngagementInvitationApp extends StatelessWidget {
  const EngagementInvitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We listen to the AppConfigManager globally so that ANY dashboard edit
    // (colors, fonts, toggles, language, names) immediately triggers hot-rebuild
    return ListenableBuilder(
      listenable: AppConfigManager.instance,
      builder: (context, _) {
        final manager = AppConfigManager.instance;

        return MaterialApp(
          title: manager.coupleNames,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: manager.accentColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: manager.primaryColor,
              primary: manager.primaryColor,
              secondary: manager.secondaryColor,
              surface: manager.accentColor,
            ),
            fontFamily: manager.bodyFont,
          ),
          locale: Locale(manager.selectedLanguage),
          builder: (context, child) {
            return Directionality(
              textDirection: manager.textDirection,
              child: child!,
            );
          },
          home: const InvitationHomePage(),
        );
      },
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Global Keys for precise section scrolling
  final GlobalKey _storyKey = GlobalKey();
  final GlobalKey _countdownKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _venueKey = GlobalKey();
  final GlobalKey _rsvpKey = GlobalKey();

  bool _showLanding = true;
  bool _isTransitioning = false;
  bool _fadeOverlay = false;

  @override
  void initState() {
    super.initState();
    // Cache the opened state inside widget lifecycle
    _showLanding = !AppConfigManager.instance.isOpened;

    // If the visitor already opened the invitation earlier (saved in localStorage),
    // we can trigger background music to continue playing on first click/hover
    if (AppConfigManager.instance.isOpened && AppConfigManager.instance.musicPlayingStateSaved) {
      Future.delayed(const Duration(milliseconds: 500), () {
        // Attempt to play, caught gracefully by browser autoplay checker
        AppAudioService.instance.play();
      });
    }
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToRsvp() => _scrollToSection(_rsvpKey);
  void _scrollToStory() => _scrollToSection(_storyKey);
  void _scrollToCountdown() => _scrollToSection(_countdownKey);
  void _scrollToGallery() => _scrollToSection(_galleryKey);
  void _scrollToVenue() => _scrollToSection(_venueKey);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final opened = manager.isOpened;

    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        return Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              // 1. Main Scrollable Website (Rendered once opened)
              if (opened)
                Positioned.fill(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        HeroSection(onScrollToRsvp: _scrollToRsvp),
                        if (manager.showStory)
                          KeyedSubtree(key: _storyKey, child: const StorySection()),
                        if (manager.showCountdown)
                          KeyedSubtree(key: _countdownKey, child: const CountdownSection()),
                        if (manager.showGallery)
                          KeyedSubtree(key: _galleryKey, child: const GallerySection()),
                        const GuestGallerySection(),
                        if (manager.showLocation)
                          KeyedSubtree(key: _venueKey, child: const LocationSection()),
                        if (manager.showSchedule) const ScheduleSection(),
                        if (manager.showGift) const GiftSection(),
                        if (manager.showRsvp)
                          KeyedSubtree(key: _rsvpKey, child: const RsvpSection()),
                        const ThankYouSection(),
                        const FooterSection(),
                      ],
                    ),
                  ),
                ),

              // 2. Floating Premium Navbar (only if invitation is opened and transition finished)
              if (opened && !_isTransitioning)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: FloatingNavbar(
                      onScrollToStory: _scrollToStory,
                      onScrollToCountdown: _scrollToCountdown,
                      onScrollToGallery: _scrollToGallery,
                      onScrollToVenue: _scrollToVenue,
                      onScrollToRsvp: _scrollToRsvp,
                    ),
                  ),
                ),

              // 3. Floating Background Music Controller
              if (opened && manager.showMusic)
                const MusicController(),

              // 4. Welcome Cinematic Video Intro & Landing Screen Overlay
              if (_showLanding)
                Positioned.fill(
                  child: LandingScreen(
                    onCompleted: () async {
                      // 1. Instantly trigger white glow cover
                      setState(() {
                        _isTransitioning = true;
                        _fadeOverlay = true;
                      });

                      // 2. Open the dynamic invitation state globally
                      // This instantly builds and mounts the website behind the scenes!
                      manager.openInvitation();

                      // 3. Give 50ms for frame to paint, then trigger AnimatedOpacity fade-out
                      await Future.delayed(const Duration(milliseconds: 50));
                      if (mounted) {
                        setState(() {
                          _fadeOverlay = false; // Transition opacity from 1.0 to 0.0
                        });
                      }

                      // 4. Wait for the fade duration (1400ms)
                      await Future.delayed(const Duration(milliseconds: 1400));

                      // 5. Cleanly unmount both overlay and landing screen from the tree
                      if (mounted) {
                        setState(() {
                          _isTransitioning = false;
                          _showLanding = false;
                        });
                      }
                    },
                  ),
                ),

              // 5. Cinematic Transition White Glow Dissolve Overlay (rendered at the very top of Stack)
              if (_isTransitioning)
                TransitionOverlay(
                  isTransitioning: _fadeOverlay,
                  duration: const Duration(milliseconds: 1400),
                ),
            ],
          ),
        );
      },
    );
  }
}
