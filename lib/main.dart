import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_settings.dart';
import 'screens/login_screen.dart';
import 'services/crash_logger.dart';
import 'services/notification_service.dart';
import 'services/tray_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics (Android/iOS) ou Firestore logger (Windows/desktop)
  CrashLogger.setupFlutterErrorHandler();

  // firebase_messaging ne supporte pas Windows/Linux — mais les notifications
  // locales (flutter_local_notifications) fonctionnent sur toutes les plateformes
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.linux) {
    try {
      await NotificationService.initialize();
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    await TrayService.instance.initialize();
  }

  // Capture les erreurs async hors contexte Flutter
  await runZonedGuarded(
    () async => runApp(const ConcertothequeApp()),
    (error, stack) => CrashLogger.recordError(error, stack, fatal: true),
  );
}

class ConcertothequeApp extends StatelessWidget {
  const ConcertothequeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettings,
      builder: (context, _) {
        return MaterialApp(
          title: 'Concertothèque',
          debugShowCheckedModeBanner: false,
          themeMode: appSettings.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6B35),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6B35),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF12121A),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
