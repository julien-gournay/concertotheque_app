import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for linux. Run FlutterFire CLI.',
        );
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not configured for this platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtq3G5WmZyvPZG2I1_rdmJSX9rO_BuLuw',
    appId: '1:983582489419:android:9bed2591728c13721006ce',
    messagingSenderId: '983582489419',
    projectId: 'concertotheque',
    storageBucket: 'concertotheque.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7uLoKwtTxhFh3s14a1S95P3CN1oVPazQ',
    appId: '1:983582489419:ios:31fd242362c790671006ce',
    messagingSenderId: '983582489419',
    projectId: 'concertotheque',
    storageBucket: 'concertotheque.firebasestorage.app',
    iosBundleId: 'com.example.concertothequeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_MACOS_API_KEY',
    appId: 'REPLACE_WITH_MACOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    iosBundleId: 'REPLACE_WITH_MACOS_BUNDLE_ID',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDx63Mw0FKY4kuIMXxks6eneRabuvl0rbs',
    appId: '1:983582489419:web:384cf9d6ca940c541006ce',
    messagingSenderId: '983582489419',
    projectId: 'concertotheque',
    authDomain: 'concertotheque.firebaseapp.com',
    storageBucket: 'concertotheque.firebasestorage.app',
    measurementId: 'G-FRZFN3BNFD',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDx63Mw0FKY4kuIMXxks6eneRabuvl0rbs',
    appId: '1:983582489419:web:c7d022dc130a2dd31006ce',
    messagingSenderId: '983582489419',
    projectId: 'concertotheque',
    authDomain: 'concertotheque.firebaseapp.com',
    storageBucket: 'concertotheque.firebasestorage.app',
    measurementId: 'G-5H68THSY1V',
  );

}