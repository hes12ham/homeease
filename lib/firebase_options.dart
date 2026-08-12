import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummy-replace-if-needed',
    appId: '1:796568810415:android:c45d04c6c259ea846bb55a',
    messagingSenderId: '796568810415',
    projectId: 'homeease-cf79b',
    storageBucket: 'homeease-cf79b.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummy-replace-if-needed',
    appId: '1:796568810415:web:9a49d5795d4d2e396bb55a',
    messagingSenderId: '796568810415',
    projectId: 'homeease-cf79b',
    storageBucket: 'homeease-cf79b.firebasestorage.app',
    authDomain: 'homeease-cf79b.firebaseapp.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummy-replace-if-needed',
    appId: '1:796568810415:ios:0000000000000000',
    messagingSenderId: '796568810415',
    projectId: 'homeease-cf79b',
    storageBucket: 'homeease-cf79b.firebasestorage.app',
    iosBundleId: 'com.homeease.app',
  );
}
