import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashLogger {
  static bool get _useCrashlytics => Platform.isAndroid || Platform.isIOS;

  static void setupFlutterErrorHandler() {
    if (_useCrashlytics) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    } else {
      FlutterError.onError = (details) =>
          recordError(details.exception, details.stack, fatal: true);
    }
  }

  /// Retourne null si succès, le message d'erreur sinon.
  static Future<String?> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    if (_useCrashlytics) {
      await FirebaseCrashlytics.instance
          .recordError(error, stack, fatal: fatal);
      return null;
    }

    // Desktop → Firestore sous users/{uid}/crash_logs pour respecter les règles
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final collection = uid != null
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('crash_logs')
          : FirebaseFirestore.instance.collection('crash_logs');

      await collection.add({
        'error': error.toString(),
        'stack': stack?.toString() ?? '',
        'platform': Platform.operatingSystem,
        'fatal': fatal,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('CrashLogger: log envoyé à Firestore (uid=$uid)');
      return null;
    } catch (e) {
      debugPrint('CrashLogger: échec Firestore — $e');
      return e.toString();
    }
  }
}
