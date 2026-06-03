# Concertothèque — Guide des notifications Windows

## Vue d'ensemble

L'app utilise deux mécanismes complémentaires :

| Mécanisme | Déclencheur | Fonctionne si l'app est fermée ? |
|---|---|---|
| Notification locale | Code Flutter / bouton dans l'app | Non (app doit tourner) |
| Notification via Firestore inbox | Firebase Console / Cloud Function / autre client | Non — mais le tray garde l'app active |

> **Pourquoi pas FCM ?** Firebase Cloud Messaging ne supporte pas Windows desktop nativement. Le SDK `firebase_messaging` est limité à Android, iOS et macOS. Le système **inbox Firestore** décrit ci-dessous offre un comportement équivalent tant que l'app tourne en barre des tâches (system tray).

---

## 1. Notification locale depuis l'app Flutter

### API directe

```dart
import 'services/notification_service.dart';

await NotificationService.show(
  title: 'Concert demain !',
  body: 'Taylor Swift · Stade de France · 20h',
);
```

### Via InboxService (raccourci)

```dart
import 'services/inbox_service.dart';

await InboxService.showLocal(
  title: 'Rappel',
  body: 'Concert dans 1 heure : David Guetta',
);
```

### Cas d'usage recommandés
- Confirmer l'ajout d'un concert
- Rappel J-1 pour un concert à venir (déclenché au démarrage de l'app)
- Confirmation d'export CSV

---

## 2. Notification depuis Firebase Console (sans code)

C'est le moyen le plus simple pour envoyer une notification "push" vers l'app Windows.

### Étapes

1. Ouvrir [console.firebase.google.com](https://console.firebase.google.com)
2. Sélectionner le projet **Concertothèque**
3. Aller dans **Firestore Database**
4. Naviguer dans la collection :
   ```
   users / {uid-utilisateur} / inbox
   ```
5. Cliquer **+ Ajouter un document** (ID auto)
6. Ajouter les champs suivants :

| Champ | Type | Valeur |
|---|---|---|
| `title` | string | Titre de la notification |
| `body` | string | Corps du message |
| `read` | boolean | `false` |
| `createdAt` | timestamp | *(cliquer "Heure actuelle du serveur")* |

7. Cliquer **Enregistrer**

L'app détecte le document en quelques secondes, affiche la notification Windows Toast, puis met `read` à `true` automatiquement.

### Trouver l'UID de l'utilisateur

Dans la console Firebase → **Authentication** → onglet **Users** → colonne **User UID**.

---

## 3. Notification depuis une Cloud Function

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin     = require('firebase-admin');
admin.initializeApp();

/**
 * Envoie une notification à un utilisateur Concertothèque.
 * Appel : sendNotification({ uid, title, body })
 */
exports.sendNotification = functions.https.onCall(async (data) => {
  const { uid, title, body } = data;

  if (!uid || !title) {
    throw new functions.https.HttpsError('invalid-argument', 'uid et title requis');
  }

  await admin.firestore()
    .collection('users').doc(uid)
    .collection('inbox').add({
      title,
      body:      body ?? '',
      read:      false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

  return { success: true };
});
```

### Appel depuis un autre client Flutter

```dart
final functions = FirebaseFunctions.instance;
await functions.httpsCallable('sendNotification').call({
  'uid':   'uid-de-l-utilisateur',
  'title': 'Nouveau concert partagé',
  'body':  'Julien t\'a ajouté un concert',
});
```

---

## 4. Notification planifiée (rappel J-1)

Pour programmer un rappel la veille d'un concert, appelle ce code au démarrage ou dans un timer :

```dart
import 'services/notification_service.dart';
import 'services/evenement_service.dart';

Future<void> scheduleConcertReminders() async {
  final concerts = await EvenementService().fetchAll();
  final tomorrow = DateTime.now().add(const Duration(days: 1));

  for (final concert in concerts) {
    if (concert.date.year  == tomorrow.year  &&
        concert.date.month == tomorrow.month &&
        concert.date.day   == tomorrow.day) {
      await NotificationService.show(
        title: 'Concert demain 🎵',
        body:  '${concert.nomEvent}'
               '${concert.lieuNom.isNotEmpty ? " · ${concert.lieuNom}" : ""}'
               '${concert.ville.isNotEmpty   ? ", ${concert.ville}"   : ""}',
        id: concert.id.hashCode.abs(),
      );
    }
  }
}
```

---

## 5. Structure Firestore de l'inbox

```
users/
  {uid}/
    inbox/             ← collection écoutée en temps réel
      {docId}/
        title    : string    — Titre affiché dans la notification
        body     : string    — Corps du message
        read     : boolean   — false = non lu, true = déjà notifié
        createdAt: timestamp — Date de création (tri chronologique)
```

### Règles Firestore recommandées

```javascript
// Ne laisser lire/écrire inbox qu'à l'utilisateur propriétaire
match /users/{userId}/inbox/{doc} {
  allow read, write: if request.auth.uid == userId;
}
```

---

## 6. Prérequis techniques

| Composant | Version | Rôle |
|---|---|---|
| `flutter_local_notifications` | ^21.0.0 | Affichage des toasts Windows |
| `flutter_local_notifications_windows` | (inclus) | Backend natif Windows |
| `tray_manager` | ^0.2.3 | Maintien de l'app active en arrière-plan |
| `cloud_firestore` | (déjà installé) | Listener temps réel (inbox) |

### GUID de l'app (ne pas modifier)

```
B3F7E8A2-1D4C-4F9E-8B6A-7C2D5E0F3A91
```

Ce GUID est utilisé dans :
- `notification_service.dart` → `WindowsInitializationSettings`
- `concertotheque.iss` → `AppId`

---

## 7. Test rapide

Depuis les **Paramètres** de l'app → section **Notifications** → bouton **Tester la notification**.

Cette action envoie immédiatement une notification locale pour vérifier que le système fonctionne correctement.
