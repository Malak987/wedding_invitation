/// Editable onboarding content — same spirit as the rest of `lib/dashboard/`:
/// change text or swap an asset path here without touching any widget code.
///
/// `imageAsset` should point to a real screenshot of that section of the
/// live site (e.g. captured at 1170x2532 and cropped to the section). Put
/// the files under `assets/images/tutorial/` and add that folder to the
/// `assets:` list in `pubspec.yaml`.
///
/// IMPORTANT: every step below (except [finalStep], the closing "thank you"
/// screen) MUST carry a real [imageAsset]. The overlay always prefers the
/// screenshot over the emoji card — the emoji-only layout is reserved
/// strictly for the very last, purely celebratory screen. This is on
/// purpose: the very first thing a guest sees when the tutorial opens has
/// to be a real picture of the invitation, never just text and an emoji.
class TutorialStep {
  final String? imageAsset;
  final String icon; // emoji fallback / accent shown above the title
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;

  const TutorialStep({
    this.imageAsset,
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
  });
}

class TutorialData {
  TutorialData._();

  static const String skip = 'skip';

  static const List<TutorialStep> steps = [
    // Step 1 — opens with the real hero screenshot, not a blank emoji card.
    TutorialStep(
      imageAsset: 'assets/images/tutorial/hero.png',
      icon: '✨',
      titleAr: 'أهلاً بكم في دعوتنا',
      titleEn: 'Welcome to Our Invitation',
      descAr:
          'شكراً لمشاركتنا هذه اللحظة الغالية. هنا هتلاقوا صورة العروسين وتاريخ المناسبة وميعادها ومكانها. خلونا نوريكم بسرعة إزاي تستخدموا الدعوة.',
      descEn:
          'Thank you for celebrating this special day with us. Here you can see the couple\'s photo, the date, time, and venue. Let us quickly show you how to use the invitation.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/story.png',
      icon: '❤️',
      titleAr: 'قصتنا',
      titleEn: 'Our Story',
      descAr:
          'اسحبوا الشريط الدائري في النص يمين وشمال عشان تقارنوا صورة زمان بصورتنا دلوقتي، وهتلاقوا تحتها اقتباس بيحكي بداية حكايتنا.',
      descEn:
          'Drag the round slider left or right to compare an old photo with a recent one, and read the short quote below about how our story began.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/countdown.png',
      icon: '⏳',
      titleAr: 'العد التنازلي',
      titleEn: 'Countdown',
      descAr:
          'عداد حي بيوضّحلكم بالظبط كام يوم وساعة ودقيقة وثانية باقية لحد يوم الفرحة.',
      descEn:
          'A live counter shows you exactly how many days, hours, minutes, and seconds remain until our special day.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/gallery.png',
      icon: '📸',
      titleAr: 'الألبوم',
      titleEn: 'Gallery',
      descAr:
          'تصفحوا مجموعة من أحلى صورنا الشخصية قبل ما توصلوا لتفاصيل الحفل.',
      descEn:
          'Browse a curated set of our favorite personal photos before getting into the event details.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/location.png',
      icon: '📍',
      titleAr: 'مكان الحفل',
      titleEn: 'The Venue',
      descAr:
          'هتلاقوا اسم القاعة والمحافظة والتاريخ والموعد، واضغطوا على زر "احصل على الاتجاهات" عشان تفتحوا الموقع مباشرة على خرائط جوجل.',
      descEn:
          'Here you\'ll find the venue name, city, date, and time. Tap "Get Directions" to open the exact location directly in Google Maps.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/schedule.png',
      icon: '📅',
      titleAr: 'برنامج الخطوبة',
      titleEn: 'The Engagement Schedule',
      descAr:
          'اطلعوا على التوقيت الزمني لسهرة الحفل، من بداية الحفل لحد ختام السهرة، عشان تخططوا لوقتكم صح.',
      descEn:
          'Check the timeline of the celebration, from the start of the event until the evening wraps up, so you can plan your time.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/upload.png',
      icon: '📤',
      titleAr: 'ذكريات اليوم',
      titleEn: "Today's Memories",
      descAr:
          'يوم الفرح، اضغطوا على "شارك صورك وفيديوهاتك" وارفعوا اللي التقطتوه من الحفل — هيوصلنا مباشرة ونحتفظ بيه معانا كذكرى.',
      descEn:
          'On the wedding day, tap "Share your photos and videos" to upload what you captured — it reaches us directly and becomes part of our memories.',
    ),
    // RSVP — the most important flow, explained in three focused steps.
    TutorialStep(
      imageAsset: 'assets/images/tutorial/rsvp_intro.png',
      icon: '✅',
      titleAr: 'تأكيد الحضور — أهم خطوة',
      titleEn: 'Confirm Attendance — The Most Important Step',
      descAr:
          'دي أهم خطوة في الدعوة كلها! اضغطوا على زر "تأكيد الحضور" عشان تقولولنا هتحضروا معانا ولا لأ، وده بيساعدنا نحضّر لاستقبالكم صح.',
      descEn:
          'This is the most important step in the whole invitation! Tap "Confirm Attendance" to let us know whether you\'ll be joining us — it helps us prepare properly to welcome you.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/rsvp_form.png',
      icon: '📝',
      titleAr: 'بطاقة الرد: بياناتكم وعدد الحضور',
      titleEn: 'The RSVP Card: Your Details & Guest Count',
      descAr:
          'هتلاقوا نموذج بسيط فيه: هل هتحضروا (نعم / آسف)، اسمكم، وعدد الحاضرين من قائمة منسدلة (1 = أنتم بس، 2 = أنتم + شخص تاني، وهكذا). في الآخر فيه مساحة تقدروا تسيبوا فيها رسالة تهنئة قصيرة للعروسين، وبعدين اضغطوا "إرسال الرد".',
      descEn:
          'You\'ll find a simple form: whether you\'re attending (Yes / Sorry), your name, and a dropdown to set the guest count (1 = just you, 2 = you plus one, and so on). At the end there\'s space for a short congratulation message to the couple, then tap "Send Response".',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/rsvp_calendar.png',
      icon: '📆',
      titleAr: 'تم الإرسال! متنسوش التقويم',
      titleEn: "Sent! Don't Forget the Calendar",
      descAr:
          'بعد الإرسال هتوصلكم رسالة "تم تأكيد الحضور" تأكيدًا إن ردكم اتسجل، ومعاها زر "إضافة للتقويم" — اضغطوا عليه عشان ميوم الفرح ينضاف على تقويم موبايلكم على طول.',
      descEn:
          'After sending, you\'ll see a "Confirmed" message showing your response was recorded, along with an "Add to Calendar" button — tap it to save the wedding date straight to your phone\'s calendar.',
    ),

    // Closing informational step — who made the invitation.
    TutorialStep(
      imageAsset: 'assets/images/tutorial/m2f.png',
      icon: '💻',
      titleAr: 'تم تصميم هذه الدعوة بواسطة M2F',
      titleEn: 'Crafted by M2F',
      descAr:
      'إذا أعجبتكم هذه التجربة، يمكنكم التواصل معنا عبر واتساب أو فيسبوك لتصميم دعوة إلكترونية مميزة تناسب مناسبتكم.',
      descEn:
      'Loved this experience? Contact us via WhatsApp or Facebook to create a premium digital invitation for your special occasion.',
    ),
  ];

  static const TutorialStep finalStep = TutorialStep(
    icon: '🎉',
    titleAr: 'تمام، جاهزين!',
    titleEn: 'You\'re Ready!',
    descAr:
        'نتمنى نستمتعوا بالتجربة. شكراً لمشاركتنا فرحتنا، ونتمنالكم وقت حلو وإنتوا بتستكشفوا الدعوة.',
    descEn:
        'We hope you enjoy this interactive invitation. Thank you for being part of our special day. Have a wonderful experience!',
  );
}
