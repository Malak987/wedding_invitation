import 'package:flutter/material.dart';
import '../core/extensions.dart';
import '../utils/web_runtime_stub.dart'
    if (dart.library.html) '../utils/web_runtime.dart';

/// A robust local-storage-backed state manager that holds all
/// editable configurations of the Engagement Invitation. It supports
/// dynamic theme color changing, custom typography, toggling sections,
/// saving state across refreshes, and instant localized updates.
class AppConfigManager extends ChangeNotifier {
  // Static instance for simple globally shared access
  static AppConfigManager? _instance;
  static AppConfigManager get instance {
    _instance ??= AppConfigManager();
    return _instance!;
  }

  // Fallback defaults
  String _brideName = 'ميرنا';
  String _groomName = 'سيف';
  String _eventDate = '2026-08-23';
  String _eventTime = '7:00 مساءً';
  String _eventDay = 'الأحد';
  String _venueName = 'قاعة برادايس';
  String _venueAddress = 'سوهاج ، مصر';
  String _storyText = 'بدأت قصتنا بلقاء بسيط تحول إلى حب حقيقي، وها نحن اليوم نبدأ فصلاً جديداً من حياتنا معاً، بإذن الله.';
  String _countdownTarget = '2026-08-23T19:00:00';
  String _googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=26.569541148546833,31.70995890878019';
  String _phoneNumber = '+201142803143';
  String _whatsappNumber = '+201142803143';
  String _facebookUrl = 'https://www.facebook.com/profile.php?id=61591828140123';

  // Aesthetic Colors
  String _primaryColor = '0xFFC9A66B'; // Gold
  String _secondaryColor = '0xFF6B4F3B'; // Deep warm brown
  String _accentColor = '0xFFFDF7F2'; // Soft beige background tint

  // Font Choices
  String _headingFont = 'Playfair';
  String _bodyFont = 'Cairo';

  // Section Toggles
  bool _showStory = true;
  bool _showCountdown = true;
  bool _showGallery = true;
  bool _showLocation = true;
  bool _showSchedule = true;
  bool _showMusic = true;

  // Music Settings
  double _musicVolume = 0.5;
  bool _musicMuted = false;
  bool _musicPlayingStateSaved = false; // Remember music state across sessions

  // App Settings
  String _selectedLanguage = 'ar';
  bool _isOpened = false;

  // Getters
  String get brideName => _brideName;
  String get groomName => _groomName;
  String get coupleNames => _selectedLanguage == 'ar' ? '$_groomName & $_brideName' : '$_groomName & $_brideName';
  String get eventDate => _eventDate;
  String get eventTime => _eventTime;
  String get eventDay => _eventDay;

  static const List<String> _monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// A natural-reading, human formatted date (e.g. "12 ديسمبر 2026"
  /// instead of the raw ISO string "2026-12-12"), which prevents the
  /// awkward mixed-direction look ISO dates get inside Arabic RTL text.
  String get eventDateReadable {
    try {
      final parsed = DateTime.parse(_eventDate);
      if (_selectedLanguage == 'ar') {
        return parsed.toReadableDate();
      }
      return '${parsed.day} ${_monthsEn[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return _eventDate;
    }
  }

  /// A full, naturally-ordered Arabic/English sentence combining the
  /// weekday and the readable date, e.g. "السبت الموافق 12 ديسمبر 2026".
  String get eventDateLine {
    if (_selectedLanguage == 'ar') {
      return '$_eventDay الموافق $eventDateReadable';
    }
    return '$_eventDay, $eventDateReadable';
  }

  /// The time prefixed naturally, e.g. "الساعة 7:00 مساءً".
  String get eventTimeLine {
    if (_selectedLanguage == 'ar') {
      return 'الساعة $_eventTime';
    }
    return 'at $_eventTime';
  }
  String get venueName => _venueName;
  String get venueAddress => _venueAddress;
  String get storyText => _storyText;
  String get countdownTarget => _countdownTarget;
  String get googleMapsUrl => _googleMapsUrl;
  String get phoneNumber => _phoneNumber;
  String get whatsappNumber => _whatsappNumber;
  String get facebookUrl => _facebookUrl;

  Color get primaryColor => Color(int.parse(_primaryColor));
  Color get secondaryColor => Color(int.parse(_secondaryColor));
  Color get accentColor => Color(int.parse(_accentColor));

  String get headingFont => _headingFont;
  String get bodyFont => _bodyFont;

  bool get showStory => _showStory;
  bool get showCountdown => _showCountdown;
  bool get showGallery => _showGallery;
  bool get showLocation => _showLocation;
  bool get showSchedule => _showSchedule;
  bool get showMusic => _showMusic;

  double get musicVolume => _musicVolume;
  bool get musicMuted => _musicMuted;
  bool get musicPlayingStateSaved => _musicPlayingStateSaved;

  String get selectedLanguage => _selectedLanguage;
  bool get isOpened => _isOpened;

  // TextDirection helper
  TextDirection get textDirection => _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  // Constructor runs load automatically
  AppConfigManager() {
    loadFromLocalStorage();
  }

  /// Read variables safely from browser localStorage (Web only; falls back
  /// to defaults everywhere else via the conditional [WebRuntime] import).
  void loadFromLocalStorage() {
    try {
      String read(String key, String fallback) => WebRuntime.readStorage(key) ?? fallback;

      _brideName = read('brideName', _brideName);
      _groomName = read('groomName', _groomName);
      _eventDate = read('eventDate', _eventDate);
      _eventTime = read('eventTime', _eventTime);
      _eventDay = read('eventDay', _eventDay);
      _venueName = read('venueName', _venueName);
      _venueAddress = read('venueAddress', _venueAddress);
      _storyText = read('storyText', _storyText);
      _countdownTarget = read('countdownTarget', _countdownTarget);
      _googleMapsUrl = read('googleMapsUrl', _googleMapsUrl);
      _phoneNumber = read('phoneNumber', _phoneNumber);
      _whatsappNumber = read('whatsappNumber', _whatsappNumber);
      _facebookUrl = read('facebookUrl', _facebookUrl);

      _primaryColor = read('primaryColor', _primaryColor);
      _secondaryColor = read('secondaryColor', _secondaryColor);
      _accentColor = read('accentColor', _accentColor);

      _headingFont = read('headingFont', _headingFont);
      _bodyFont = read('bodyFont', _bodyFont);

      _showStory = read('showStory', 'true') == 'true';
      _showCountdown = read('showCountdown', 'true') == 'true';
      _showGallery = read('showGallery', 'true') == 'true';
      _showLocation = read('showLocation', 'true') == 'true';
      _showSchedule = read('showSchedule', 'true') == 'true';
      _showMusic = read('showMusic', 'true') == 'true';

      _musicVolume = double.tryParse(read('musicVolume', '')) ?? _musicVolume;
      _musicMuted = read('musicMuted', 'false') == 'true';
      _musicPlayingStateSaved = read('musicPlayingStateSaved', 'false') == 'true';

      _selectedLanguage = read('selectedLanguage', _selectedLanguage);
      // ملحوظة مهمة: `isOpened` متتقريش من التخزين عمداً.
      // كل زيارة/Refresh لازم يبدأ بشاشة الافتتاح عشان فيديو المقدمة
      // يظهر في كل مرة. القيمة بتتغير لـ true في الذاكرة فقط بعد ما
      // الضيف يدوس على الختم ويكمل الفيديو.
      // Important: `isOpened` is intentionally NOT restored from storage.
      // Every fresh visit/reload must start on the landing screen so the
      // intro video plays every time — it flips to true in memory only,
      // after the guest taps the wax seal and the video finishes.
      _isOpened = false;
    } catch (e) {
      debugPrint('LocalStorage is not available: $e');
    }
  }

  /// Save current configuration fields to browser storage.
  void saveToLocalStorage() {
    try {
      void write(String key, String value) => WebRuntime.writeStorage(key, value);

      write('brideName', _brideName);
      write('groomName', _groomName);
      write('eventDate', _eventDate);
      write('eventTime', _eventTime);
      write('eventDay', _eventDay);
      write('venueName', _venueName);
      write('venueAddress', _venueAddress);
      write('storyText', _storyText);
      write('countdownTarget', _countdownTarget);
      write('googleMapsUrl', _googleMapsUrl);
      write('phoneNumber', _phoneNumber);
      write('whatsappNumber', _whatsappNumber);
      write('facebookUrl', _facebookUrl);

      write('primaryColor', _primaryColor);
      write('secondaryColor', _secondaryColor);
      write('accentColor', _accentColor);

      write('headingFont', _headingFont);
      write('bodyFont', _bodyFont);

      write('showStory', _showStory.toString());
      write('showCountdown', _showCountdown.toString());
      write('showGallery', _showGallery.toString());
      write('showLocation', _showLocation.toString());
      write('showSchedule', _showSchedule.toString());
      write('showMusic', _showMusic.toString());

      write('musicVolume', _musicVolume.toString());
      write('musicMuted', _musicMuted.toString());
      write('musicPlayingStateSaved', _musicPlayingStateSaved.toString());

      write('selectedLanguage', _selectedLanguage);
      // `isOpened` is no longer persisted: it is runtime-only state so
      // the intro video plays on every visit (see loadFromLocalStorage).
    } catch (e) {
      debugPrint('Error saving to LocalStorage: $e');
    }
    notifyListeners();
  }

  /// Set configurations directly (used by Admin Dashboard)
  void updateConfig({
    String? brideName,
    String? groomName,
    String? eventDate,
    String? eventTime,
    String? eventDay,
    String? venueName,
    String? venueAddress,
    String? storyText,
    String? countdownTarget,
    String? googleMapsUrl,
    String? phoneNumber,
    String? whatsappNumber,
    String? facebookUrl,
    String? primaryColor,
    String? secondaryColor,
    String? accentColor,
    String? headingFont,
    String? bodyFont,
    bool? showStory,
    bool? showCountdown,
    bool? showGallery,
    bool? showLocation,
    bool? showSchedule,
    bool? showMusic,
    double? musicVolume,
    bool? musicMuted,
    bool? musicPlayingStateSaved,
  }) {
    if (brideName != null) _brideName = brideName;
    if (groomName != null) _groomName = groomName;
    if (eventDate != null) _eventDate = eventDate;
    if (eventTime != null) _eventTime = eventTime;
    if (eventDay != null) _eventDay = eventDay;
    if (venueName != null) _venueName = venueName;
    if (venueAddress != null) _venueAddress = venueAddress;
    if (storyText != null) _storyText = storyText;
    if (countdownTarget != null) _countdownTarget = countdownTarget;
    if (googleMapsUrl != null) _googleMapsUrl = googleMapsUrl;
    if (phoneNumber != null) _phoneNumber = phoneNumber;
    if (whatsappNumber != null) _whatsappNumber = whatsappNumber;
    if (facebookUrl != null) _facebookUrl = facebookUrl;

    if (primaryColor != null) _primaryColor = primaryColor;
    if (secondaryColor != null) _secondaryColor = secondaryColor;
    if (accentColor != null) _accentColor = accentColor;

    if (headingFont != null) _headingFont = headingFont;
    if (bodyFont != null) _bodyFont = bodyFont;

    if (showStory != null) _showStory = showStory;
    if (showCountdown != null) _showCountdown = showCountdown;
    if (showGallery != null) _showGallery = showGallery;
    if (showLocation != null) _showLocation = showLocation;
    if (showSchedule != null) _showSchedule = showSchedule;
    if (showMusic != null) _showMusic = showMusic;

    if (musicVolume != null) _musicVolume = musicVolume;
    if (musicMuted != null) _musicMuted = musicMuted;
    if (musicPlayingStateSaved != null) _musicPlayingStateSaved = musicPlayingStateSaved;

    saveToLocalStorage();
  }

  /// Sets the dynamic language and instantly triggers layout change
  void setLanguage(String lang) {
    _selectedLanguage = lang;
    saveToLocalStorage();
  }

  /// Marks the invitation opened and plays music
  void openInvitation() {
    _isOpened = true;
    _musicPlayingStateSaved = true; // start playing music
    saveToLocalStorage();
  }

  /// Closes and resets the experience for demo/re-test
  void resetInvitation() {
    _isOpened = false;
    _musicPlayingStateSaved = false;
    saveToLocalStorage();
  }
}
