/// ============================================================
/// MUSIC SETTINGS — Local Dashboard
/// ============================================================

class AppMusic {
  AppMusic._();

  /// File must exist inside assets/music/
  /// IMPORTANT: do NOT include the "assets/" prefix here — audioplayers
  /// adds it automatically. Correct: 'music/background_music.mp3'
  /// Wrong:     'assets/music/background_music.mp3' (causes a 404 on
  /// web, which the browser reports as "Format error / MEDIA_ELEMENT_ERROR").
  /// Also avoid spaces/special characters in the file name — rename to
  /// something like 'background_music.mp3' to prevent web URL issues.
  static const String trackAsset = 'assets/music/wedding_music.mp3';

  static const bool autoPlay = true;
  static const bool loop = true;

  /// 0.0 -> 1.0
  static const double volume = 0.5;
}
