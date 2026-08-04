import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/config_manager.dart';
import 'services/tutorial_manager.dart';
import 'widgets/landing_screen.dart';
import 'widgets/lazy_mount.dart';
import 'widgets/tutorial_overlay.dart';
import 'widgets/navbar.dart';
import 'sections/hero_section.dart';
import 'sections/story_section.dart';
import 'sections/countdown_section.dart';
import 'sections/gallery_section.dart';
import 'sections/location_section.dart';
import 'sections/schedule_section.dart';
import 'sections/rsvp_section.dart';
import 'sections/thank_you_section.dart';
import 'sections/footer_section.dart';
import 'sections/music_player.dart';
import 'sections/guest_gallery_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  final GlobalKey _scheduleKey = GlobalKey();

  bool _showLanding = true;
  bool _showTutorial = false;

  @override
  void initState() {
    super.initState();
    // Every visit/reload starts on the landing screen so the intro video
    // plays every time — `isOpened` is never restored from storage.
    _showLanding = true;

    // The tutorial can only appear after the invitation is opened, which
    // (per the landing flow above) always happens via LandingScreen's
    // onCompleted callback — so nothing to do here on startup.
    _showTutorial = false;
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

  void _scrollToStory() => _scrollToSection(_storyKey);
  void _scrollToCountdown() => _scrollToSection(_countdownKey);
  void _scrollToGallery() => _scrollToSection(_galleryKey);
  void _scrollToVenue() => _scrollToSection(_venueKey);
  void _scrollToSchedule() => _scrollToSection(_scheduleKey);

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
                        HeroSection(onScrollToVenue: _scrollToVenue),
                        if (manager.showStory)
                          KeyedSubtree(
                            key: _storyKey,
                            child: LazyMount(
                              placeholderHeight: 500,
                              builder: (_) => const StorySection(),
                            ),
                          ),
                        if (manager.showCountdown)
                          KeyedSubtree(
                            key: _countdownKey,
                            child: LazyMount(
                              placeholderHeight: 360,
                              builder: (_) => const CountdownSection(),
                            ),
                          ),
                        if (manager.showGallery)
                          KeyedSubtree(
                            key: _galleryKey,
                            child: LazyMount(
                              placeholderHeight: 600,
                              builder: (_) => const GallerySection(),
                            ),
                          ),
                        LazyMount(
                          placeholderHeight: 500,
                          builder: (_) => const GuestGallerySection(),
                        ),
                        if (manager.showLocation)
                          KeyedSubtree(
                            key: _venueKey,
                            child: LazyMount(
                              placeholderHeight: 500,
                              builder: (_) => const LocationSection(),
                            ),
                          ),
                        if (manager.showSchedule)
                          KeyedSubtree(
                            key: _scheduleKey,
                            child: LazyMount(
                              placeholderHeight: 500,
                              builder: (_) => const ScheduleSection(),
                            ),
                          ),
                        LazyMount(
                          placeholderHeight: 700,
                          builder: (_) => const RsvpSection(),
                        ),
                        LazyMount(
                          placeholderHeight: 300,
                          builder: (_) => const ThankYouSection(),
                        ),
                        LazyMount(
                          placeholderHeight: 150,
                          builder: (_) => const FooterSection(),
                        ),
                      ],
                    ),
                  ),
                ),

              // 2. Floating Premium Navbar (only once the invitation is opened)
              if (opened)
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
                      onScrollToSchedule: _scrollToSchedule,
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
                    key: const ValueKey('landing_screen'),
                    onCompleted: () {
                      // Immediate, single-frame handoff: the moment the seal video
                      // finishes, open the invitation and remove the landing screen
                      // in the same frame — no staged delays, no fade overlay, so
                      // there is nothing in between for the eye to catch.
                      manager.openInvitation();
                      setState(() {
                        _showLanding = false;
                        _showTutorial = !TutorialManager.instance.hasCompleted;
                      });
                    },
                  ),
                ),

              // 5. First-time interactive tutorial — shown once, right after
              // the invitation opens. Sits above everything, blurs/darkens
              // and locks the site behind it until finished or skipped.
              if (_showTutorial)
                TutorialOverlay(
                  key: const ValueKey('tutorial_overlay'),
                  onFinished: () => setState(() => _showTutorial = false),
                ),
            ],
          ),
        );
      },
    );
  }
}
