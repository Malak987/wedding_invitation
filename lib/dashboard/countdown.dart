import 'invitation_data.dart';

/// ============================================================
/// COUNTDOWN SETTINGS — Local Dashboard
/// ============================================================
/// The actual target date lives in invitation_data.dart
/// (countdownTargetDate) to avoid duplicating the event date.
/// This file only controls countdown display behavior.
/// ============================================================

class AppCountdown {
  AppCountdown._();

  static String get targetDateIso => InvitationData.countdownTargetDate;

  /// Show the countdown section at all
  static const bool enabled = true;

  /// Text shown after the countdown reaches zero
  static const String finishedMessage = 'حان الوقت!';
}
