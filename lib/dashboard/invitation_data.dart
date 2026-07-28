/// ============================================================
/// INVITATION DATA — Local Dashboard
/// ============================================================
/// Edit ONLY the values below to customize the invitation.
/// Do NOT touch any widget or section file.
/// ============================================================

class InvitationData {
  InvitationData._();

  // ---------- Names ----------
  static const String brideName = 'سارة';
  static const String groomName = 'أحمد';

  /// Shown together, e.g. "أحمد & سارة"
  static String get coupleNames => '$groomName & $brideName';

  // ---------- Hero Texts ----------
  static const String invitationTitle = 'دعوة خطوبة';
  static const String invitationSubtitle = 'يسعدنا دعوتكم لمشاركتنا فرحتنا';
  static const String invitationDescription =
      'بكل حب وسعادة، ندعوكم لحضور حفل خطوبتنا، ونتشرف بتواجدكم معنا في هذه اللحظة الغالية على قلوبنا.';

  // ---------- Our Story ----------
  static const String storyTitle = 'قصتنا';
  static const String storyText =
      'بدأت قصتنا بلقاء بسيط تحول إلى حب حقيقي، وها نحن اليوم نبدأ فصلاً جديداً من حياتنا معاً، بإذن الله.';

  // ---------- Event Details ----------
  static const String eventDate = '2026-12-12'; // yyyy-MM-dd
  static const String eventTime = '7:00 مساءً';
  static const String eventDayName = 'السبت';
  static const String venueName = 'قاعة الأفراح الملكية';
  static const String venueAddress = 'القاهرة، مصر';

  // ---------- Countdown ----------
  /// ISO 8601 format used by CountdownTimer
  static const String countdownTargetDate = '2026-12-12T19:00:00';

  // ---------- Contact ----------
  static const String phoneNumber = '+201000000000';
  static const String whatsappNumber = '+201000000000';

  // ---------- RSVP ----------
  static const String rsvpTitle = 'يسعدنا تأكيد حضوركم';
  static const String rsvpDescription =
      'نرجو تأكيد الحضور عبر واتساب أو الاتصال لتسهيل الترتيبات.';

  // ---------- Thank You ----------
  static const String thankYouTitle = 'شكراً لكم';
  static const String thankYouMessage =
      'وجودكم يزيدنا فرحاً وسعادة، شكراً لمشاركتكم أجمل لحظات حياتنا.';

  // ---------- Footer ----------
  static const String footerText = 'صُممت هذه الدعوة بكل حب © 2026';
}
