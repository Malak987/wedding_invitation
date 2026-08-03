/// Editable onboarding content — same spirit as the rest of `lib/dashboard/`:
/// change text or swap an asset path here without touching any widget code.
///
/// `imageAsset` should point to a real screenshot of that section of the
/// live site (e.g. captured at 1170x2532 and cropped to the section). Put
/// the files under `assets/images/tutorial/` and add that folder to the
/// `assets:` list in `pubspec.yaml`. Until a screenshot exists, the overlay
/// automatically falls back to a themed icon card so nothing breaks.
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
    TutorialStep(
      icon: '✨',
      titleAr: 'أهلاً بكم في دعوتنا',
      titleEn: 'Welcome to Our Invitation',
      descAr: 'شكراً لمشاركتنا هذه اللحظة الغالية. قبل أن تبدأوا، خلونا نوريكم بسرعة إزاي تستخدموا الدعوة.',
      descEn: 'Thank you for celebrating this special day with us. Before you begin, let us quickly show you how to use the invitation.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/hero.png',
      icon: '📜',
      titleAr: 'تفاصيل المناسبة',
      titleEn: 'The Wedding Details',
      descAr: 'هنا هتلاقوا صورة العروسين وتاريخ المناسبة وميعادها ومكانها، وكل المعلومات الأساسية.',
      descEn: 'Here you\'ll find the couple\'s photo, the date, time, venue, and all the essential details.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/story.png',
      icon: '❤️',
      titleAr: 'قصتنا',
      titleEn: 'Our Story',
      descAr: 'اسحبوا الشريط يمين وشمال عشان تقارنوا صور الطفولة بالصور الحديثة.',
      descEn: 'Drag the slider left or right to compare childhood memories with our recent photos.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/countdown.png',
      icon: '⏳',
      titleAr: 'العد التنازلي',
      titleEn: 'Countdown',
      descAr: 'شوفوا بالظبط الوقت المتبقي لحد يوم الفرحة.',
      descEn: 'See exactly how much time remains until our special day.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/gallery.png',
      icon: '📸',
      titleAr: 'الألبوم',
      titleEn: 'Gallery',
      descAr: 'تصفحوا أحلى لحظاتنا مع بعض، واضغطوا على أي صورة لتكبيرها.',
      descEn: 'Browse our favorite memories together by opening any photo.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/schedule.png',
      icon: '📅',
      titleAr: 'برنامج الخطوبة',
      titleEn: 'The Engagement Schedule',
      descAr: 'اطلعوا على الجدول الزمني لفعاليات يوم الفرح من بدايته لنهايته.',
      descEn: 'Check the timeline of the wedding day from beginning to end.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/upload.png',
      icon: '📤',
      titleAr: 'ذكريات اليوم',
      titleEn: "Today's Memories",
      descAr: 'بعد المناسبة، ارفعوا صوركم وفيديوهاتكم عشان توصلنا مباشرة ونحتفظ بيها مع باقي الذكريات.',
      descEn: 'After the wedding, upload your photos and videos so they are automatically shared with the bride and groom.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/rsvp_intro.png',
      icon: '✅',
      titleAr: 'تأكيد الحضور',
      titleEn: 'Confirm Attendance',
      descAr: 'دي أهم خطوة عندنا! اضغطوا على زر "تأكيد الحضور" عشان تقولولنا هتحضروا معانا ولا لأ.',
      descEn: 'This is the most important step! Tap the "Confirm Attendance" button to let us know if you\'ll be joining us.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/rsvp_form.png',
      icon: '📝',
      titleAr: 'بياناتكم وعدد الحضور',
      titleEn: 'Your Details & Guest Count',
      descAr: 'اختاروا "نعم سأحضر" أو "آسف لا أستطيع"، اكتبوا اسمكم، وحددوا عدد الحاضرين (1 = أنت لوحدك، 2 = أنت + شخص واحد آخر). تقدروا كمان تسيبولنا رسالة حلوة.',
      descEn: 'Choose "Yes, I\'ll attend" or "Sorry, I can\'t make it", enter your name, and set how many guests are coming (1 = just you, 2 = you plus one). You can also leave us a lovely message.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/rsvp_calendar.png',
      icon: '📆',
      titleAr: 'متنسوش تضيفوا الموعد لجوجل كاليندر',
      titleEn: "Don't Forget Google Calendar",
      descAr: 'بعد ما تأكدوا حضوركم، هتظهرلكم رسالة تأكيد فيها زر "إضافة للتقويم" — اضغطوا عليه عشان تضيفوا موعد الفرح على جوجل كاليندر وتوصلكم تذكير قبل الموعد بوقت كافي.',
      descEn: 'After confirming, you\'ll see a confirmation message with an "Add to Calendar" button — tap it to add the wedding date to your Google Calendar and get a reminder before the big day.',
    ),
    TutorialStep(
      imageAsset: 'assets/images/tutorial/location.png',
      icon: '📍',
      titleAr: 'مكان الحفل',
      titleEn: 'The Venue',
      descAr: 'اضغطوا على زر الاتجاهات عشان تفتحوا الموقع مباشرة على خرائط جوجل.',
      descEn: 'Tap the directions button to open the venue directly in Google Maps.',
    ),
  ];

  static const TutorialStep finalStep = TutorialStep(
    icon: '🎉',
    titleAr: 'تمام، جاهزين!',
    titleEn: 'You\'re Ready!',
    descAr: 'نتمنى نستمتعوا بالتجربة. شكراً لمشاركتنا فرحتنا، ونتمنالكم وقت حلو وإنتوا بتستكشفوا الدعوة.',
    descEn: 'We hope you enjoy this interactive invitation. Thank you for being part of our special day. Have a wonderful experience!',
  );
}
