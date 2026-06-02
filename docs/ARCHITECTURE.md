# Architecture

Ce document décrit la structure du code de Concertothèque, les responsabilités de chaque couche, et les flux de données principaux.

---

## Structure des dossiers

```
lib/
├── main.dart              ← Point d'entrée, initialisation Firebase + services
├── app_settings.dart      ← État global (thème, notifications, tray)
│
├── models/
│   ├── artiste.dart       ← Modèle Artiste
│   ├── concert.dart       ← Modèle Evenement (concert)
│   └── lieu.dart          ← Modèle Lieu (salle)
│
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── dashboard_screen.dart
│   ├── concerts_screen.dart
│   ├── concert_detail_screen.dart
│   ├── evenement_edit_screen.dart
│   ├── artistes_screen.dart
│   ├── artiste_detail_screen.dart
│   ├── artiste_edit_screen.dart
│   ├── lieux_screen.dart
│   ├── lieu_detail_screen.dart
│   ├── lieu_edit_screen.dart
│   ├── settings_screen.dart
│   └── about_screen.dart
│
├── services/
│   ├── evenement_service.dart   ← CRUD concerts (Firestore)
│   ├── artiste_service.dart     ← CRUD artistes (Firestore)
│   ├── lieu_service.dart        ← CRUD salles (Firestore)
│   ├── notification_service.dart← Notifications (Windows Toast / FCM)
│   ├── inbox_service.dart       ← Listener Firestore inbox → notifications
│   ├── reminder_service.dart    ← Rappels concerts à venir
│   ├── tray_service.dart        ← Zone de notification Windows
│   ├── autostart_service.dart   ← Démarrage automatique Windows
│   ├── export_service.dart      ← Export CSV
│   └── crash_logger.dart        ← Rapport d'erreurs
│
└── widgets/
    ├── main_layout.dart          ← Layout principal avec sidebar
    └── artiste_picker_dialog.dart← Dialog multi-sélection artistes
```

---

## Initialisation (main.dart)

L'app s'initialise dans cet ordre au démarrage :

```
1. WidgetsFlutterBinding.ensureInitialized()
2. Firebase.initializeApp()          ← Firebase (Auth + Firestore + Messaging)
3. CrashLogger.setupFlutterErrorHandler()
4. NotificationService.initialize()  ← Windows Toast ou FCM selon plateforme
5. TrayService.instance.initialize() ← Icône zone de notification Windows
6. runZonedGuarded(runApp(...))       ← Lance l'app avec filet de sécurité async
```

L'écran d'accueil est toujours `LoginScreen`. Il n'y a pas de vérification automatique de session : l'utilisateur se reconnecte à chaque lancement (Firebase Auth maintient le token localement mais l'app ne l'exploite pas pour sauter le login).

---

## État global (AppSettings)

`AppSettings` est un singleton `ChangeNotifier` accessible via la variable globale `appSettings`.

```dart
final AppSettings appSettings = AppSettings();  // global singleton

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _pushNotificationsEnabled = true;
  bool _minimizeToTray = false;
}
```

Il est écouté par :
- `main.dart` via `AnimatedBuilder` pour reconstruire le thème de l'app
- `TrayService` qui réagit aux changements de `minimizeToTray`
- `NotificationService` qui vérifie `pushNotificationsEnabled` avant d'afficher une notification

> L'état de `AppSettings` n'est **pas persisté** entre deux lancements de l'app. Les paramètres reviennent à leurs valeurs par défaut à chaque redémarrage.

---

## Couche de données (Services Firestore)

Les trois services de données (`EvenementService`, `ArtisteService`, `LieuService`) suivent le même pattern :

```
Firestore
  users/{uid}/
    evenements/  ←→  EvenementService
    artistes/    ←→  ArtisteService
    lieux/       ←→  LieuService
```

Chaque service expose :

| Méthode | Description |
|---|---|
| `fetchPage(cursor, pageSize)` | Pagination avec curseur Firestore |
| `fetchAll()` | Récupère tous les documents (pour export) |
| `stream()` | Stream temps réel (pour listes réactives) |
| `add(model)` | Crée un document |
| `update(model)` | Met à jour un document |
| `delete(id)` | Supprime un document |

La pagination utilise `startAfterDocument` de Firestore avec une taille de page de 25 éléments.

---

## Navigation

La navigation est entièrement gérée par la `MainLayout` sidebar. Il n'y a pas de routeur nommé (`go_router` ou `Navigator 2.0`) — chaque item de la sidebar pousse un écran dans la pile `Navigator`.

```
LoginScreen
  └─→ MainLayout (sidebar)
        ├─→ DashboardScreen
        ├─→ ConcertsScreen → ConcertDetailScreen → EvenementEditScreen
        ├─→ ArtistesScreen → ArtisteDetailScreen → ArtisteEditScreen
        ├─→ LieuxScreen    → LieuDetailScreen    → LieuEditScreen
        ├─→ SettingsScreen
        └─→ AboutScreen
```

---

## Notifications — flux complet

```
Démarrage de l'app
  ├─→ ReminderService.checkAndNotify()
  │     └─→ Cherche concerts dans les 7 et 1 jours
  │           └─→ NotificationService.show() si pas déjà notifié
  │
  └─→ InboxService.start()
        └─→ Firestore listener sur users/{uid}/inbox
              └─→ Nouveau doc (read: false) détecté
                    ├─→ NotificationService.show()
                    └─→ Marque read: true dans Firestore

Paramètres utilisateur
  └─→ appSettings.pushNotificationsEnabled = false
        └─→ NotificationService.canShow() retourne false → aucune notif
```

---

## Intégration Windows spécifique

### Zone de notification (TrayService)

`TrayService` est un singleton qui implémente `TrayListener` et `WindowListener`.

```
appSettings.minimizeToTray = true
  └─→ TrayService._onSettingChanged()
        └─→ _setupTray()
              ├─→ trayManager.setIcon('windows/runner/resources/concertotheque.ico')
              └─→ trayManager.setContextMenu([Ouvrir, Quitter])

Utilisateur clique "Fermer" la fenêtre
  └─→ onWindowClose()
        ├─→ minimizeToTray = true  → windowManager.hide()
        └─→ minimizeToTray = false → exit(0)
```

### Démarrage automatique (AutostartService)

Modifie le registre Windows directement via `dart:io` et `Process.run('reg', ...)` :

```
HKCU\Software\Microsoft\Windows\CurrentVersion\Run
  └─→ "Concertothèque" = "C:\...\concertotheque_app.exe"
```

L'installeur Inno Setup nettoie automatiquement cette clé lors de la désinstallation.

---

## Gestion des erreurs

| Contexte | Mécanisme | Destination |
|---|---|---|
| Erreurs Flutter synchrones | `FlutterError.onError` | Crashlytics (mobile) / Firestore (desktop) |
| Erreurs async non capturées | `runZonedGuarded` | Idem |
| Erreurs métier (CRUD) | `try/catch` dans les services | SnackBar dans l'UI |
| Auth requise récente | `FirebaseAuthException('requires-recent-login')` | Dialog + déconnexion |

---

## Thème et apparence

Le thème est défini dans `main.dart` et reconstruit dynamiquement via `AnimatedBuilder(animation: appSettings)` :

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF6B35)),  // orange
    useMaterial3: true,
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF6B35), brightness: Brightness.dark),
    scaffoldBackgroundColor: Color(0xFF12121A),
    useMaterial3: true,
  ),
  themeMode: appSettings.themeMode,  // system / light / dark
)
```

Couleurs principales :
- Orange accent : `#FF6B35`
- Fond sombre : `#12121A`
- Card sombre : `#1E1E2C`
- Séparateur : `#2A2A3C`
