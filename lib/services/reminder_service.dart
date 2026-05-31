import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_settings.dart';
import '../services/evenement_service.dart';
import '../services/notification_service.dart';

/// Vérifie au démarrage si des concerts ont lieu dans 7 ou 1 jour
/// et envoie une notification locale si ce n'est pas déjà fait.
///
/// Les rappels déjà envoyés sont mémorisés dans SharedPreferences
/// pour éviter de notifier plusieurs fois si l'app est relancée
/// plusieurs fois le même jour.
class ReminderService {
  static const _prefKey = 'shown_reminders_v1';

  static Future<void> checkAndNotify() async {
    // Sortie rapide : évite un appel Firestore inutile si l'option est désactivée
    if (!appSettings.pushNotificationsEnabled) return;
    try {
      final prefs  = await SharedPreferences.getInstance();
      final shown  = Set<String>.from(prefs.getStringList(_prefKey) ?? []);
      final now    = DateTime.now();
      final today  = DateTime(now.year, now.month, now.day);

      final concerts = await EvenementService().fetchAll();
      bool changed = false;

      for (final concert in concerts) {
        if (concert.isArchive) continue;

        final concertDay = DateTime(
            concert.date.year, concert.date.month, concert.date.day);
        final diff = concertDay.difference(today).inDays;

        for (final jours in [7, 1]) {
          if (diff != jours) continue;

          final key = '${concert.id}_j$jours';
          if (shown.contains(key)) continue; // déjà notifié aujourd'hui

          final lieu = [
            if (concert.lieuNom.isNotEmpty) concert.lieuNom,
            if (concert.ville.isNotEmpty) concert.ville,
          ].join(', ');

          await NotificationService.show(
            title: jours == 1
                ? '🎵 Concert demain !'
                : '🎵 Concert dans $jours jours',
            body: lieu.isNotEmpty
                ? '${concert.nomEvent}  ·  $lieu'
                : concert.nomEvent,
            id: key.hashCode.abs(),
          );

          shown.add(key);
          changed = true;
          debugPrint('ReminderService: rappel J-$jours → ${concert.nomEvent}');
        }
      }

      if (changed) {
        // Purge des vieux rappels (concerts déjà passés) pour ne pas gonfler la liste
        final validIds = concerts.map((e) => e.id).toSet();
        shown.removeWhere((k) {
          final id = k.split('_j').first;
          return !validIds.contains(id);
        });
        await prefs.setStringList(_prefKey, shown.toList());
      }
    } catch (e) {
      debugPrint('ReminderService error: $e');
    }
  }

  /// Réinitialise les rappels mémorisés (utile pour les tests).
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }
}
