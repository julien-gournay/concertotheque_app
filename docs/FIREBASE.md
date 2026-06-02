# Firebase — Configuration et intégration

Ce document explique comment Concertothèque se connecte à Firebase, comment est organisée la base de données, et comment reconfigurer l'app sur un nouveau projet Firebase.

---

## Services Firebase utilisés

| Service | Plateforme | Usage |
|---|---|---|
| **Firebase Auth** | Toutes | Authentification email/mot de passe |
| **Cloud Firestore** | Toutes | Stockage des données utilisateur (concerts, artistes, salles) |
| **Firebase Messaging (FCM)** | Android / iOS uniquement | Notifications push depuis le serveur |
| **Firebase Crashlytics** | Android / iOS uniquement | Rapports de crash |

> Windows n'est pas supporté par FCM ni Crashlytics. L'app utilise des alternatives desktop : les notifications Windows Toast via `flutter_local_notifications` et un logger de crash dans Firestore.

---

## Fichiers de configuration

### `lib/firebase_options.dart`

Fichier auto-généré par la CLI Firebase (`flutterfire configure`). Il contient les clés API et identifiants de projet pour chaque plateforme.

```dart
// Exemple (Windows)
static const FirebaseOptions windows = FirebaseOptions(
  apiKey: '...',
  appId: '...',
  messagingSenderId: '983582489419',
  projectId: 'concertotheque',
  storageBucket: 'concertotheque.firebasestorage.app',
  authDomain: 'concertotheque.firebaseapp.com',
);
```

**Ce fichier ne doit pas être commité dans un dépôt public** s'il contient des clés API. Dans ce projet, les clés sont côté client et non secrètes, mais les règles Firestore doivent être configurées correctement.

### `android/app/google-services.json`

Fichier de configuration Firebase pour Android, téléchargé depuis la Firebase Console. Référencé automatiquement par le plugin Gradle.

---

## Structure Firestore

Toutes les données sont isolées par utilisateur via l'UID Firebase Auth.

```
firestore/
└── users/
    └── {uid}/
        ├── evenements/        ← Concerts
        │   └── {docId}/
        │       ├── nomEvent   (string)
        │       ├── date       (timestamp)
        │       ├── typeCode   (string: CON | FES | SOI | SHO | COM)
        │       ├── placement  (string: FOSS | GRAD | CAT1..4 | CARO)
        │       ├── prixBillet (number)
        │       ├── depenseSup (number)
        │       ├── lieuNom    (string)
        │       ├── ville      (string)
        │       ├── pays       (string)
        │       ├── artistes   (array<string>)
        │       ├── affiche    (string, URL)
        │       ├── cover      (string, URL)
        │       └── isArchive  (bool)
        │
        ├── artistes/          ← Artistes
        │   └── {docId}/
        │       ├── nom        (string)
        │       ├── genre      (string, optional)
        │       └── photo      (string, URL, optional)
        │
        ├── lieux/             ← Salles
        │   └── {docId}/
        │       ├── nom        (string)
        │       ├── ville      (string)
        │       ├── pays       (string, default: "France")
        │       ├── adresse    (string, optional)
        │       ├── type       (string: salle_de_concert | arena | stade | parc | expo | boite | chateau | monument | autre)
        │       ├── capacite   (number, optional)
        │       ├── photo      (string, URL, optional)
        │       └── siteWeb    (string, URL, optional)
        │
        ├── inbox/             ← Notifications entrantes (serveur → app)
        │   └── {docId}/
        │       ├── title      (string)
        │       ├── body       (string)
        │       ├── read       (bool)
        │       └── createdAt  (timestamp)
        │
        └── crash_logs/        ← Logs d'erreurs desktop
            └── {docId}/
                ├── error      (string)
                ├── stack      (string)
                ├── platform   (string)
                ├── fatal      (bool)
                └── timestamp  (timestamp)
```

---

## Règles de sécurité Firestore

Chaque utilisateur ne peut lire et modifier que ses propres données. Exemple de règles à appliquer dans la Firebase Console :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /crash_logs/{docId} {
      allow write: if true;   // logs anonymes si non authentifié
      allow read: if false;
    }
  }
}
```

---

## Flux d'authentification

```
App launch
  └─→ LoginScreen
        ├─→ FirebaseAuth.signInWithEmailAndPassword()
        │     ├─→ Succès → InboxService.start() + ReminderService.check() → DashboardScreen
        │     └─→ Échec → message d'erreur
        └─→ FirebaseAuth.createUserWithEmailAndPassword() (inscription)
              └─→ Succès → DashboardScreen
```

L'état d'authentification n'est pas persisté automatiquement dans l'app : la `LoginScreen` est toujours le point d'entrée. Firebase Auth gère la session via son propre mécanisme de persistance (token local).

---

## Notifications

### Desktop (Windows)

FCM n'est pas supporté sur Windows. L'app utilise deux mécanismes alternatifs :

**1. InboxService** — Écoute en temps réel la collection `users/{uid}/inbox` dans Firestore.
Quand un document avec `read: false` est ajouté (depuis Firebase Console ou une Cloud Function), l'app affiche une notification Windows Toast et marque le document comme lu.

```dart
// Déclencher une notification depuis Firebase Console :
// Collection : users/{uid}/inbox
// Document : { title: "Titre", body: "Message", read: false }
```

**2. ReminderService** — Au démarrage de l'app, vérifie les concerts à venir dans les 7 jours ou 1 jour et affiche une notification locale. Les rappels déjà affichés sont mémorisés dans `SharedPreferences` (clé `shown_reminders_v1`) pour éviter les doublons.

**GUID Windows Notifications :** `B3F7E8A2-1D4C-4F9E-8B6A-7C2D5E0F3A91`
Ce GUID identifie l'app dans le centre de notifications Windows. Il est défini dans `notification_service.dart` **et** dans `concertotheque.iss`. Les deux doivent toujours être identiques.

### Mobile (Android / iOS)

L'app utilise Firebase Cloud Messaging (FCM). Le token FCM est récupéré au démarrage et loggué en console (non stocké côté serveur dans cette version).

```dart
final token = await FirebaseMessaging.instance.getToken();
```

Les notifications reçues en foreground sont affichées via `flutter_local_notifications`.

---

## Crash reporting

| Plateforme | Mécanisme |
|---|---|
| Android / iOS | Firebase Crashlytics |
| Windows / macOS | Firestore (`crash_logs/`) |

Les erreurs Flutter non gérées sont capturées par `FlutterError.onError` et les erreurs async par `runZonedGuarded`.

---

## Reconfigurer Firebase sur un nouveau projet

1. Crée un projet Firebase sur [console.firebase.google.com](https://console.firebase.google.com).
2. Active **Authentication** (méthode : Email/Password).
3. Active **Firestore** en mode production.
4. Installe la CLI Firebase et FlutterFire :
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
5. Connecte-toi et configure le projet :
   ```bash
   firebase login
   flutterfire configure --project=<ton-project-id>
   ```
   Cela régénère `lib/firebase_options.dart` et `android/app/google-services.json`.
6. Applique les règles de sécurité Firestore (voir section ci-dessus).
7. Mets à jour le `messagingSenderId` si tu changes de projet.
