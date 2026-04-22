import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import du moteur Firebase
import 'firebase_options.dart'; // Import des clés générées par FlutterFire
import 'app_settings.dart';
import 'screens/login_screen.dart';

// On transforme le main en "async" pour pouvoir attendre Firebase
void main() async {
  // 1. Indispensable pour lier Flutter aux ressources natives (Windows/Android)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialisation de Firebase avec les options de ton projet
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ConcertothequeApp());
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
          // Ton écran de connexion s'affichera au démarrage
          home: const LoginScreen(),
        );
      },
    );
  }
}
