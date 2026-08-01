// Generated-style Firebase options for the Sofi/Mirna invitation.
//
// IMPORTANT:
// The public Hosting init endpoint exposed apiKey/projectId/messagingSenderId,
// but not the Firebase Web App ID. Firestore can be wired with the values below,
// but Firebase Cloud Messaging Web needs the real `appId` and a VAPID key.
//
// Best final setup command from the project root:
//   flutterfire configure --project=sofamirna-2026
//
// Then replace this file with the generated one.

// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCe2AKfu2IscejauuGiqUuV__5GlruZ_PQ',
    appId: '1:583646649398:web:f4161850590660edd48c97',
    messagingSenderId: '583646649398',
    projectId: 'sofamirna-2026',
    authDomain: 'sofamirna-2026.firebaseapp.com',
    storageBucket: 'sofamirna-2026.firebasestorage.app',
    measurementId: 'G-59H8F6MHHX',
  );
  // Reusing project values so the app remains compilable on all Flutter targets.
  // For production mobile builds, run `flutterfire configure` and use the real
  // Android/iOS app options/files.
  static const FirebaseOptions android = web;
  static const FirebaseOptions ios = web;
  static const FirebaseOptions macos = web;
  static const FirebaseOptions windows = web;
  static const FirebaseOptions linux = web;
}
