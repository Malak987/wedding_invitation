import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
import '../core/responsive.dart';
import '../widgets/animated_text.dart';
import '../widgets/background_particles.dart';
import '../widgets/invite_button.dart';
import '../animations/fade_in.dart';
import '../animations/floating_widget.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onScrollToRsvp;

  const HeroSection({super.key, required this.onScrollToRsvp});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final primary = manager.primaryColor;
    final isMobile = Responsive.isMobile(context);

    // Standard high-quality imagery from existing asset index
    const String bgAsset = 'assets/images/1.jpg';

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Elegant Background Image with Fallback and Parallax-like fit
          Positioned.fill(
            child: Image.asset(
              bgAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      manager.secondaryColor.withOpacity(0.95),
                      manager.secondaryColor.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Luxury Dark Vignette Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Glowing light particles
          const Positioned.fill(
            child: BackgroundParticles(particleCount: 30),
          ),

          // Premium Double Gold Border Frame (Luxury Wedding Aesthetic)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 24),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primary.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating Decorative Heart/Ring
          Positioned(
            top: isMobile ? 80 : 120,
            child: FloatingWidget(
              duration: const Duration(seconds: 4),
              child: Icon(
                Icons.favorite_sharp,
                color: primary.withOpacity(0.8),
                size: isMobile ? 28 : 36,
              ),
            ),
          ),

          // Hero Text Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    Localization.get(lang, 'invite_title').toUpperCase(),
                    style: TextStyle(
                      fontFamily: manager.bodyFont,
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.w300,
                      color: primary,
                      letterSpacing: isMobile ? 4 : 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedText(
                  text: manager.coupleNames,
                  delay: const Duration(milliseconds: 400),
                  style: TextStyle(
                    fontFamily: manager.headingFont,
                    fontSize: isMobile ? 44 : 84,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 650),
                    child: Text(
                      Localization.get(lang, 'invite_desc'),
                      style: TextStyle(
                        fontFamily: manager.bodyFont,
                        fontSize: isMobile ? 14 : 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                FadeIn(
                  delay: const Duration(milliseconds: 950),
                  child: InviteButton(
                    label: Localization.get(lang, 'rsvp_submit'),
                    icon: Icons.favorite_border_sharp,
                    onPressed: onScrollToRsvp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
