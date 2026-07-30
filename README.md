# دعوة خطوبة رقمية — Flutter Web Template

مشروع Flutter Web كامل لدعوة خطوبة (سيف & ميرنا)، بدون أي Backend أو Firebase.
كل التخصيص الفعلي يتم من ملف واحد أساسي:
**`lib/services/config_manager.dart`** (القيم الافتراضية أعلى الملف)، بالإضافة
إلى استبدال الصور والموسيقى داخل `assets/`.

> ملاحظة: النسخة الأصلية من هذا المشروع كانت تحتوي على مجلد `lib/dashboard/`
> بالكامل (ألوان، خطوط، نصوص، صور...) لكنه لم يكن متصلاً فعليًا بالتطبيق —
> تم حذف كل هذه الملفات غير المستخدمة لتفادي اللبس. الملفان المتبقيان في
> `lib/dashboard/` (`links.dart` و `gallery_config.dart`) هما الوحيدان
> المستخدمان فعليًا.

## 1) تجهيز المشروع (مرة واحدة فقط)

هذا المشروع يحتوي فقط على `lib/` و `assets/` و `pubspec.yaml` و `web/`.
إذا احتجت لاحقًا دعم منصات أخرى (Android/iOS/Desktop)، يتم توليدها تلقائيًا:

```bash
cd engagement_invite
flutter create . --platforms=web
flutter pub get
flutter run -d chrome
```

> لدعم Android/iOS أيضًا لاحقًا: `flutter create . --platforms=web,android,ios`

## 2) التخصيص بدون الحاجة لفهم الكود بالكامل

### أ) بيانات العروسين والحفل
افتح `lib/services/config_manager.dart` وعدّل القيم الافتراضية أعلى الكلاس:

| المتغير | المحتوى |
|---|---|
| `_brideName` / `_groomName` | أسماء العروسين (حاليًا: ميرنا / سيف) |
| `_eventDate` | تاريخ الخطوبة بصيغة `yyyy-MM-dd` |
| `_eventTime` | وقت الخطوبة، مثال `7:00 مساءً` |
| `_eventDay` | اسم اليوم، مثال `السبت` |
| `_venueName` / `_venueAddress` | اسم وعنوان القاعة |
| `_storyText` | نص قصة الحب |
| `_countdownTarget` | تاريخ ووقت العد التنازلي بصيغة ISO |
| `_googleMapsUrl` | رابط خرائط جوجل للقاعة (حاليًا بالإحداثيات المحددة) |
| `_phoneNumber` / `_whatsappNumber` | أرقام التواصل |
| `_facebookUrl` | رابط صفحة الفيسبوك (يظهر زر متابعة تحت رسالة الشكر) |
| `_primaryColor` / `_secondaryColor` / `_accentColor` | ألوان التطبيق (Hex) |

النصوص الثابتة (عناوين الأقسام، نصوص الأزرار) موجودة في `lib/core/localization.dart`
منظمة تحت مفتاح `ar` و `en`.

### ب) رابط مشاركة صور الضيوف
افتح `lib/dashboard/links.dart` وغيّر `guestPhotosFormUrl` برابط الفورم بتاعك
(التعليمات موجودة بجانبه في نفس الملف خطوة بخطوة).

### ج) موعد فتح استقبال الصور
افتح `lib/dashboard/gallery_config.dart` وغيّر `galleryOpenDate`
(حاليًا مضبوط على منتصف ليلة يوم الخطوبة نفسه).

### د) الصور
- الصورة الرئيسية (خلفية أول قسم + البرواز القوسي): `assets/images/1.jpg`
- صورة "زمان" في شريط المقارنة التفاعلي بقسم "قصتنا": `assets/images/story_young.png`
- صورة "دلوقتي" في نفس الشريط + قسم الألبوم: `assets/images/story_now.jpg`
- فيديو المقدمة (فتح الختم): `assets/images/video/s&m.mp4`

استبدل نفس الأسماء بصورك دون تعديل أي كود.

### هـ) الموسيقى
استبدل الملف `assets/music/wedding_music.mp3` بنفس الاسم.

### و) الخطوط
ضع ملفات الخط داخل `assets/fonts/` بنفس الأسماء المذكورة في `pubspec.yaml`
(PlayfairDisplay-Regular.ttf, PlayfairDisplay-Bold.ttf, Cairo-Regular.ttf, Cairo-Bold.ttf).

## 3) بنية المشروع

```
lib/
├── dashboard/    ← links.dart (رابط فورم الصور) + gallery_config.dart (موعد الفتح)
├── services/     ← config_manager.dart: كل بيانات وألوان الدعوة الحقيقية
├── core/         ← Localization, Responsive, Constants, Extensions
├── models/       ← ScheduleItem, GalleryItem
├── utils/        ← Countdown Timer, URL Launcher
├── animations/   ← FadeIn, SlideIn, ScaleIn, Parallax
├── widgets/      ← عناصر UI قابلة لإعادة الاستخدام
├── sections/     ← كل قسم من الصفحة (Hero, Story, Gallery...)
└── main.dart     ← نقطة التشغيل وربط كل الأقسام
```

الأقسام المعروضة حاليًا بالترتيب: الصفحة الرئيسية ← قصتنا (شريط تفاعلي زمان/دلوقتي)
← العد التنازلي ← الألبوم ← مشاركة صور الضيوف ← مكان الحفل ← برنامج الخطوبة
← رسالة شكر + متابعة الفيسبوك ← الفوتر.

> لا يوجد قسم لتأكيد الحضور (RSVP) في هذه النسخة — تم حذفه بالكامل بناءً على الطلب.

## 4) مشاركة صور الضيوف (بدون Backend)

بما أن المشروع بلا قاعدة بيانات، أسهل وأضمن طريقة مجانية لجمع صور
وفيديوهات الضيوف هي Google Form بسؤال "File upload"، كل ملف يرفعه
الضيف يتخزن تلقائيًا في مجلد Google Drive في حسابك الشخصي. خطوات
الإعداد بالتفصيل موجودة كتعليق داخل `lib/dashboard/links.dart`.

الزر بتاع مشاركة الصور بيظهر تلقائيًا في الموقع بعد الموعد المحدد في
`galleryOpenDate`، وقبل كده بيظهر بدلاً منه رسالة "لسه القسم مقفول".

## 5) إعادة الاستخدام لعملاء آخرين (White-label)

1. انسخ المشروع بالكامل في مجلد جديد.
2. عدّل القيم في `lib/services/config_manager.dart` و `lib/core/localization.dart`.
3. استبدل الصور والموسيقى داخل `assets/`.
4. لا حاجة لأي تعديل في `widgets/` أو `sections/` أو `animations/`.

## الحزم المستخدمة (Packages)

- `url_launcher` — لفتح واتساب / خرائط جوجل / فورم الصور / فيسبوك
- `audioplayers` — لتشغيل الموسيقى الخلفية
- `video_player` — لتشغيل فيديو فتح الختم
- `cupertino_icons` — أيقونات أساسية

لا يوجد أي Backend أو Firebase أو أي حزمة غير ضرورية.
