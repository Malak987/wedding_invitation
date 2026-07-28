import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../services/audio_service.dart';
import '../core/localization.dart';
import '../widgets/background_particles.dart';
import '../animations/fade_in.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onOpen;

  const WelcomeScreen({super.key, required this.onOpen});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _slideLeft;
  late final Animation<double> _slideRight;
  late final Animation<double> _fadeElements;
  bool _openingTriggered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Cinematic split-screen reveal (left and right gate slide)
    _slideLeft = Tween<double>(begin: 0.0, end: -1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _slideRight = Tween<double>(begin: 0.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _fadeElements = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleOpen() async {
    if (_openingTriggered) return;
    setState(() => _openingTriggered = true);

    // Play Background music immediately with smooth fade-in
    await AppAudioService.instance.play();

    // Trigger local storage save
    AppConfigManager.instance.openInvitation();

    // Begin split screen slide animation
    await _animationController.forward();

    // Call callback to reveal the app
    widget.onOpen();
  }

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final primary = manager.primaryColor;
    final secondary = manager.secondaryColor;

    return Stack(
      children: [
        // Left Gate Panel
        AnimatedBuilder(
          animation: _slideLeft,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(_slideLeft.value, 0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: secondary,
                    border: Border(
                      right: BorderSide(color: primary.withOpacity(0.5), width: 1.5),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Right Gate Panel
        AnimatedBuilder(
          animation: _slideRight,
          builder: (context, child) {
            return Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: FractionalTranslation(
                translation: Offset(_slideRight.value, 0.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondary,
                      border: Border(
                        left: BorderSide(color: primary.withOpacity(0.5), width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Beautiful Overlay Content
        if (!_animationController.isCompleted)
          FadeTransition(
            opacity: _fadeElements,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  const Positioned.fill(
                    child: BackgroundParticles(particleCount: 50, animateOnlyDownward: true),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Elegant Gold Circular Calligraphy/Frame
                            FadeIn(
                              delay: const Duration(milliseconds: 200),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: primary.withOpacity(0.6), width: 1.5),
                                ),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primary.withOpacity(0.12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.favorite_sharp, color: primary, size: 40),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Wedding Subtitle (e.g. "With love, we invite you")
                            FadeIn(
                              delay: const Duration(milliseconds: 400),
                              child: Text(
                                Localization.get(lang, 'welcome_subtitle').toUpperCase(),
                                style: TextStyle(
                                  fontFamily: manager.bodyFont,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70,
                                  letterSpacing: 4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Luxury typography couple names
                            FadeIn(
                              delay: const Duration(milliseconds: 600),
                              child: Text(
                                manager.coupleNames,
                                style: TextStyle(
                                  fontFamily: manager.headingFont,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Date Badge
                            FadeIn(
                              delay: const Duration(milliseconds: 850),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: primary.withOpacity(0.4), width: 1),
                                ),
                                child: Text(
                                  '${manager.weddingDay} • ${manager.weddingDate}',
                                  style: TextStyle(
                                    fontFamily: manager.bodyFont,
                                    fontSize: 14,
                                    color: primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 56),

                            // Centers premium button "Open Invitation"
                            FadeIn(
                              delay: const Duration(milliseconds: 1050),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: _handleOpen,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primary.withOpacity(0.45),
                                          blurRadius: 28,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          Localization.get(lang, 'open_invitation').toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: manager.bodyFont,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.mark_email_unread_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
