# دعوة خطوبة رقمية — Flutter Web Template

مشروع Flutter Web كامل لدعوة خطوبة، بدون أي Backend أو Firebase.
كل التخصيص يتم من مجلد `lib/dashboard/` واستبدال الصور داخل `assets/`.

## 1) تجهيز المشروع (مرة واحدة فقط)

هذا المشروع يحتوي فقط على `lib/` و `assets/` و `pubspec.yaml`.
مجلدات المنصات (web, android, ios...) يتم توليدها تلقائيًا بواسطة أداة Flutter:

```bash
cd engagement_invite
flutter create . --platforms=web
flutter pub get
flutter run -d chrome
```

> إذا أردت لاحقًا دعم Android/iOS أيضًا:
> `flutter create . --platforms=web,android,ios`

## 2) التخصيص بدون لمس الكود

### أ) البيانات النصية
عدّل فقط داخل `lib/dashboard/`:

| الملف | المحتوى |
|---|---|
| `invitation_data.dart` | أسماء العروسين، التاريخ، المكان، الوصف |
| `colors.dart` | كل ألوان التطبيق |
| `strings.dart` | نصوص الأزرار والعناوين الثابتة |
| `images.dart` | مسارات الصور (أسماء فقط) |
| `fonts.dart` | أسماء الخطوط |
| `links.dart` | روابط واتساب / خرائط جوجل / انستجرام |
| `music.dart` | إعدادات الموسيقى (تشغيل تلقائي، تكرار، صوت) |
| `countdown.dart` | إعدادات العد التنازلي |
| `app_config.dart` | إظهار/إخفاء أي Section بالكامل |

### ب) الصور
استبدل الملفات داخل `assets/images/...` بنفس الاسم الموجود، دون تعديل أي كود.
أسماء الملفات المطلوبة موجودة في `lib/dashboard/images.dart`.

### ج) الموسيقى
ضع ملف mp3 باسم `background_music.mp3` داخل `assets/music/`.

### د) الخطوط
ضع ملفات الخط داخل `assets/fonts/` بنفس الأسماء المذكورة في `pubspec.yaml`
(Playfair-Regular.ttf, Playfair-Bold.ttf, Cairo-Regular.ttf, Cairo-Bold.ttf).
يمكن تحميل خط Cairo و Playfair Display مجانًا من Google Fonts.

## 3) بنية المشروع

```
lib/
├── dashboard/    ← التخصيص فقط (بيانات، ألوان، صور، روابط...)
├── core/         ← Responsive, Constants, Extensions
├── theme/        ← ThemeData + Text Styles
├── models/       ← ScheduleItem, GalleryItem
├── utils/        ← Countdown Timer, URL Launcher
├── animations/   ← FadeIn, SlideIn, ScaleIn, Floating, Parallax
├── widgets/      ← عناصر UI قابلة لإعادة الاستخدام
├── sections/     ← كل قسم من الصفحة (Hero, Story, Gallery...)
└── main.dart     ← نقطة التشغيل وربط كل الأقسام
```

## 4) إعادة الاستخدام لعملاء آخرين (White-label)

لعمل نسخة جديدة لعميل مختلف:
1. انسخ المشروع بالكامل في مجلد جديد.
2. عدّل `lib/dashboard/*` فقط.
3. استبدل الصور والموسيقى داخل `assets/`.
4. لا حاجة لأي تعديل في `widgets/` أو `sections/` أو `animations/`.

`app_config.dart` يحتوي على `activeTemplate` كحقل محجوز لدعم أكثر من
تصميم (Template) مستقبلًا دون إعادة كتابة المشروع.

## الحزم المستخدمة (Packages)

- `url_launcher` — لفتح واتساب / خرائط جوجل / انستجرام
- `audioplayers` — لتشغيل الموسيقى الخلفية
- `cupertino_icons` — أيقونات أساسية

لا يوجد أي Backend أو Firebase أو أي حزمة غير ضرورية.
