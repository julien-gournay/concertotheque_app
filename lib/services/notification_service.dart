import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app_settings.dart';

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {}

class NotificationService {
  static final _local = FlutterLocalNotificationsPlugin();

  static const _channelId   = 'concertotheque_high';
  static const _channelName = 'Concertothèque';

  // GUID identique à celui de concertotheque.iss (ne pas modifier)
  static const _windowsGuid = 'B3F7E8A2-1D4C-4F9E-8B6A-7C2D5E0F3A91';

  static Future<void> initialize() async {
    if (Platform.isWindows) {
      await _initWindows();
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await _initMobile();
    }
  }

  // ── Initialisation Windows ───────────────────────────────────────────────

  static Future<void> _initWindows() async {
    const settings = WindowsInitializationSettings(
      appName: 'Concertothèque',
      appUserModelId: 'com.example.concertotheque_app',
      guid: _windowsGuid,
    );
    await _local.initialize(
        settings: const InitializationSettings(windows: settings));
  }

  // ── Initialisation mobile / macOS ────────────────────────────────────────

  static Future<void> _initMobile() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, sound: true,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios     = DarwinInitializationSettings();
    await _local.initialize(
        settings: const InitializationSettings(android: android, iOS: ios));

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId, _channelName,
          importance: Importance.high,
        ));

    FirebaseMessaging.onMessage.listen(_onFcmMessage);

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');
  }

  static void _onFcmMessage(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    show(title: n.title ?? '', body: n.body ?? '', id: message.hashCode.abs());
  }

  // ── API publique ─────────────────────────────────────────────────────────

  /// Vérifie si les notifications peuvent être envoyées :
  ///   1. L'option "Notifications push" doit être activée dans les Paramètres
  ///   2. L'OS doit avoir accordé la permission à l'application
  static Future<bool> canShow() async {
    // Vérification du réglage app (synchrone, rapide)
    if (!appSettings.pushNotificationsEnabled) return false;

    // Vérification de la permission OS (Android uniquement —
    // iOS est vérifié à l'init, Windows est géré de façon transparente par l'OS)
    if (Platform.isAndroid) {
      final impl = _local.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await impl?.areNotificationsEnabled() ?? true;
    }

    return true;
  }

  /// Affiche une notification native (Windows Toast ou Android).
  /// N'envoie rien si [canShow()] retourne false.
  static Future<void> show({
    required String title,
    required String body,
    int id = 0,
  }) async {
    if (!await canShow()) return;

    final details = Platform.isWindows
        ? const NotificationDetails(windows: WindowsNotificationDetails())
        : const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId, _channelName,
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          );

    try {
      await _local.show(id: id, title: title, body: body,
          notificationDetails: details);
    } catch (e) {
      debugPrint('NotificationService.show error: $e');
    }
  }

  /// Retourne null sur Windows (FCM non supporté).
  static Future<String?> getToken() async {
    if (Platform.isWindows) return null;
    return FirebaseMessaging.instance.getToken();
  }
}
