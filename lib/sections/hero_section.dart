import 'package:flutter/material.dart';
import '../dashboard/invitation_data.dart';
import '../dashboard/images.dart';
import '../dashboard/colors.dart';
import '../theme/text_styles.dart';
import '../core/responsive.dart';
import '../widgets/animated_text.dart';
import '../widgets/invite_button.dart';
import '../widgets/background_particles.dart';
import '../animations/floating_widget.dart';
import '../animations/fade_in.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onScrollToRsvp;

  const HeroSection({super.key, required this.onScrollToRsvp});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AppImages.backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColorsData.heroGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: AppColorsData.background.withOpacity(0.35)),
          ),
          const Positioned.fill(child: BackgroundParticles()),

          // Floating decorative ring/flower
          Positioned(
            top: 60,
            child: FloatingWidget(
              child: Icon(Icons.favorite, color: AppColorsData.primary.withOpacity(0.5), size: 34),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    InvitationData.invitationTitle,
                    style: AppTextStyles.heroSubtitle.copyWith(letterSpacing: 3),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedText(
                  text: InvitationData.coupleNames,
                  delay: const Duration(milliseconds: 400),
                  style: AppTextStyles.heroTitle.copyWith(
                    fontSize: isMobile ? 40 : 64,
                  ),
                ),
                const SizedBox(height: 20),
                FadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: Text(
                    InvitationData.invitationDescription,
                    style: AppTextStyles.heroSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 36),
                FadeIn(
                  delay: const Duration(milliseconds: 900),
                  child: InviteButton(
                    label: 'تأكيد الحضور',
                    icon: Icons.favorite_border,
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
