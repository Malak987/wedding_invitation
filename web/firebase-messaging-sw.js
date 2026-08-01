/* Firebase Cloud Messaging service worker for Flutter Web RSVP reminders.
 * This file has no backend logic; it only lets the browser receive/display
 * FCM messages after the visitor grants notification permission.
 */
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCe2AKfu2IscejauuGiqUuV__5GlruZ_PQ',
  authDomain: 'sofamirna-2026.firebaseapp.com',
  projectId: 'sofamirna-2026',
  storageBucket: 'sofamirna-2026.firebasestorage.app',
  messagingSenderId: '583646649398',
  // IMPORTANT: replace this after running `flutterfire configure` or after
  // creating a Web App in Firebase Console. FCM Web needs a real appId.
  appId: "1:583646649398:web:f4161850590660edd48c97",
  });

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notification = payload.notification || {};
  const title = notification.title || 'Engagement Reminder';
  const options = {
    body: notification.body || 'We look forward to seeing you.',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    data: payload.data || {},
  };

  self.registration.showNotification(title, options);
});
