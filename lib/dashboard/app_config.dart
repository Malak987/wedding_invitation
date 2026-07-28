/// ============================================================
/// APP CONFIG — Local Dashboard
/// ============================================================
/// Global toggles that control which sections appear and how
/// the app behaves. Useful when reselling this template and a
/// client doesn't need every section.
/// ============================================================

class AppConfig {
  AppConfig._();

  static const String appTitle = 'دعوة خطوبة أحمد & سارة';

  /// Active template. Reserved for future multi-template support
  /// (e.g. 'classic', 'modern', 'minimal').
  static const String activeTemplate = 'classic';

  // ---------- Section toggles ----------
  static const bool showStorySection = true;
  static const bool showCountdownSection = true;
  static const bool showGallerySection = true;
  static const bool showLocationSection = true;
  static const bool showScheduleSection = true;
  static const bool showGiftSection = true;
  static const bool showRsvpSection = true;
  static const bool showMusicPlayer = true;

  // ---------- Behavior ----------
  static const bool enableSmoothScroll = true;
  static const bool enableParallax = true;
  static const bool enableParticles = true;
}
