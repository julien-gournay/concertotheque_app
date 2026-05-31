import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

/// Écoute la collection Firestore `users/{uid}/inbox` en temps réel.
/// Lorsqu'un document apparaît avec `read == false`, une notification
/// locale Windows est affichée et le document est marqué comme lu.
///
/// ─── Envoyer une notification depuis Firebase Console ─────────────────────
/// 1. Ouvrir la console Firebase → Firestore Database
/// 2. Naviguer vers  users / {uid} / inbox
/// 3. Ajouter un document avec ces champs :
///       title    : "Titre de la notification"  (string)
///       body     : "Corps du message"          (string)
///       read     : false                       (boolean)
///       createdAt: <timestamp serveur>         (timestamp)
///
/// L'app détecte le document en quelques secondes et affiche une notification.
///
/// ─── Envoyer depuis une Cloud Function ────────────────────────────────────
/// exports.sendWindowsNotification = functions.https.onCall(async (data) => {
///   const { uid, title, body } = data;
///   await admin.firestore()
///     .collection('users').doc(uid).collection('inbox').add({
///       title, body, read: false, createdAt: admin.firestore.FieldValue.serverTimestamp()
///     });
/// });
///
class InboxService {
  static final _db   = FirebaseFirestore.instance;
  static StreamSubscription? _sub;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Démarre l'écoute. À appeler une fois après la connexion de l'utilisateur.
  static void start() {
    final uid = _uid;
    if (uid == null) return;
    _sub?.cancel();

    _sub = _db
        .collection('users')
        .doc(uid)
        .collection('inbox')
        .where('read', isEqualTo: false)
        // Pas d'orderBy ici — évite d'exiger un index composite Firestore
        .snapshots()
        .listen(
      (snap) async {
        for (final change in snap.docChanges
            .where((c) => c.type == DocumentChangeType.added)) {
          final data = change.doc.data();
          if (data == null) continue;

          final title = data['title'] as String? ?? '';
          final body  = data['body']  as String? ?? '';

          await NotificationService.show(
            title: title.isNotEmpty ? title : 'Concertothèque',
            body:  body,
            id:    change.doc.id.hashCode.abs(),
          );

          await change.doc.reference.update({'read': true});
        }
      },
      onError: (e) => debugPrint('InboxService stream error: $e'),
      cancelOnError: false,
    );
  }

  /// Arrête l'écoute (lors de la déconnexion).
  static void stop() {
    _sub?.cancel();
    _sub = null;
  }

  /// Envoie une notification locale depuis l'app elle-même.
  static Future<void> showLocal({
    required String title,
    required String body,
  }) => NotificationService.show(title: title, body: body);
}
