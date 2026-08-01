# خطوات توصيل دعوة الخطوبة بـ Firebase Firestore + RSVP + Calendar + Web Notifications

## 1) المشروع الحالي

المشروع مربوط في `.firebaserc` على Firebase project:

```txt
sofamirna-2026
```

رابط الاستضافة المتوقع:

```txt
https://sofamirna-2026.web.app/
```

تم إضافة كود Firebase داخل Flutter، لكن مهم جداً تعمل خطوة `flutterfire configure` للحصول على `appId` الحقيقي الخاص بالـ Web App، خصوصاً من أجل Web Push Notifications.

---

## 2) أوامر التجهيز

من داخل فولدر المشروع:

```bash
flutter pub get
```

لو FlutterFire CLI غير مثبت:

```bash
dart pub global activate flutterfire_cli
```

ثم شغل:

```bash
flutterfire configure --project=sofamirna-2026
```

اختار Web على الأقل. الأمر سيولد أو يحدث:

```txt
lib/firebase_options.dart
```

> مهم: الملف الموجود حالياً يحتوي إعدادات المشروع العامة، لكن `appId` متروك كـ placeholder. أمر `flutterfire configure` هو الطريقة الأفضل ليضع القيمة الصحيحة تلقائياً.

---

## 3) Firestore Database

من Firebase Console:

1. افتح مشروع `sofamirna-2026`.
2. ادخل Firestore Database.
3. Create database.
4. اختر Production mode.
5. اختر أقرب Region.

ثم انشر قواعد Firestore:

```bash
firebase login
firebase use sofamirna-2026
firebase deploy --only firestore:rules
```

---

## 4) Collection الخاصة بالـ RSVP

تم استخدام Collection واحدة:

```txt
guestResponses
```

كل guest له document ثابت مبني من:

```txt
eventId + guestId
```

يعني لو نفس الضيف بعت RSVP مرة ثانية، سيتم تحديث نفس document وليس إنشاء واحد جديد.

مثال:

```json
{
  "eventId": "engagement_001",
  "guestId": "guest_120",
  "guestName": "Ahmed",
  "attendanceStatus": "attending",
  "guestCount": 2,
  "message": "ألف مبروك ❤️",
  "language": "ar",
  "deviceId": "device_xxxxx",
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

لو اعتذر:

```json
{
  "attendanceStatus": "declined",
  "guestCount": 0
}
```

---

## 5) روابط الضيوف الشخصية

الأفضل ترسل لكل ضيف لينك فيه `guestId` و `guestName`:

```txt
https://sofamirna-2026.web.app/?guestId=guest_120&guestName=Ahmed
```

لو لم يتم إرسال `guestId`، الموقع سيولّد guestId محفوظ في المتصفح. هذا يعمل، لكنه يعني "رد واحد لكل جهاز/متصفح" وليس لكل ضيف حقيقي.

---

## 6) RSVP UI

تم إضافة قسم RSVP قبل Thank You.

الضيف يختار:

- نعم، سأحضر
- آسف، لا أستطيع الحضور

لو هيحضر:

- الاسم إجباري
- عدد الحضور مهم جداً ويشمل صاحب الرابط نفسه
- 1 = هو فقط
- 2 = هو وشخص آخر
- الرسالة اختيارية

لو مش هيحضر:

- الاسم إجباري
- الرسالة اختيارية
- العدد يتم حفظه 0

---

## 7) Calendar

بعد نجاح RSVP يظهر Success dialog فيه زر Add To Calendar.

- Android/Desktop: يفتح Google Calendar جاهز.
- iPhone/iPad: ينزل ملف ICS.

بيانات التقويم:

- Title: Engagement Ceremony
- Description: Join us to celebrate our special day.
- Website: https://sofamirna-2026.web.app/
- Location: من إعدادات الموقع
- Start date: من `countdownTarget`
- End date: بعد 4 ساعات
- Reminders: صباح يوم الخطوبة + قبل الحدث بساعة

---

## 8) Web Push Notifications

تم إضافة كارت بعد RSVP:

```txt
Stay Updated
Receive a reminder before the engagement.
Enable Notifications
```

لتفعيل Web Push:

1. Firebase Console.
2. Project settings.
3. Cloud Messaging.
4. Web Push certificates.
5. Generate key pair.
6. انسخ Public VAPID Key.
7. ضعه في:

```dart
// lib/dashboard/links.dart
static const String fcmWebVapidKey = 'PASTE_PUBLIC_VAPID_KEY_HERE';
```

وتأكد أن `lib/firebase_options.dart` و `web/firebase-messaging-sw.js` فيهم `appId` الحقيقي من Firebase Web App.

> ملاحظة مهمة: بدون Backend أو Cloud Functions، العميل يقدر يطلب الإذن ويحفظ FCM Token وجدول التذكيرات في Firestore، لكنه لا يستطيع وحده إرسال Push Notifications مجدولة في المستقبل. الإرسال الفعلي يحتاج لاحقاً Firebase Notifications Composer أو Cloud Function أو أي sender خارجي.

---

## 9) Build & Deploy

```bash
flutter build web --release
firebase deploy --only firestore:rules,hosting
```

أو لو القواعد منشورة بالفعل:

```bash
firebase deploy --only hosting
```
