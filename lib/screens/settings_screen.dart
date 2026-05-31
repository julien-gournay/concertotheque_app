import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../services/artiste_service.dart';
import '../services/autostart_service.dart';
import '../services/evenement_service.dart';
import '../services/export_service.dart';
import '../services/inbox_service.dart';
import '../services/lieu_service.dart';
import '../widgets/main_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _autostartEnabled;
  bool _exportingConcerts   = false;
  bool _exportingArtistes   = false;
  bool _exportingLieux      = false;
  bool _testingNotification = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      AutostartService.isEnabled().then((v) {
        if (mounted) setState(() => _autostartEnabled = v);
      });
    }
  }

  Future<void> _exportConcerts() async {
    setState(() => _exportingConcerts = true);
    try {
      final concerts = await EvenementService().fetchAll();
      if (!mounted) return;
      final path = await ExportService.exportConcertsCsv(concerts);
      if (!mounted) return;
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Concerts exportés : $path'),
          backgroundColor: const Color(0xFF26C6DA),
          duration: const Duration(seconds: 4),
        ));
      }
    } finally {
      if (mounted) setState(() => _exportingConcerts = false);
    }
  }

  Future<void> _exportArtistes() async {
    setState(() => _exportingArtistes = true);
    try {
      final artistes = await ArtisteService().fetchAll();
      if (!mounted) return;
      final path = await ExportService.exportArtistesCsv(artistes);
      if (!mounted) return;
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Artistes exportés : $path'),
          backgroundColor: const Color(0xFF26C6DA),
          duration: const Duration(seconds: 4),
        ));
      }
    } finally {
      if (mounted) setState(() => _exportingArtistes = false);
    }
  }

  Future<void> _testNotification() async {
    setState(() => _testingNotification = true);
    try {
      await InboxService.showLocal(
        title: 'Concertothèque — Test ✓',
        body:  'Les notifications Windows fonctionnent correctement.',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Notification envoyée !'),
        backgroundColor: Color(0xFF26C6DA),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur : $e'),
        backgroundColor: const Color(0xFFD32F2F),
        duration: const Duration(seconds: 4),
      ));
    } finally {
      if (mounted) setState(() => _testingNotification = false);
    }
  }

  Future<void> _exportLieux() async {
    setState(() => _exportingLieux = true);
    try {
      final lieux = await LieuService().fetchAll();
      if (!mounted) return;
      final path = await ExportService.exportLieuxCsv(lieux);
      if (!mounted) return;
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lieux exportés : $path'),
          backgroundColor: const Color(0xFF26C6DA),
          duration: const Duration(seconds: 4),
        ));
      }
    } finally {
      if (mounted) setState(() => _exportingLieux = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'Utilisateur inconnu';
    final String displayName =
        (user?.displayName == null || user!.displayName!.trim().isEmpty)
            ? 'Profil sans nom'
            : user.displayName!;

    return MainLayout(
      currentRoute: 'settings',
      child: AnimatedBuilder(
        animation: appSettings,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paramètres',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nom: $displayName',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Email: $email',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showEditProfileDialog(context, user),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Modifier le profil',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Apparence',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<ThemeMode>(
                        value: appSettings.themeMode,
                        dropdownColor: const Color(0xFF1E1E2C),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF12121A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('Suivre le système'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Clair'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Sombre'),
                          ),
                        ],
                        onChanged: (ThemeMode? mode) {
                          if (mode != null) appSettings.setThemeMode(mode);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: const Color(0xFFFF6B35),
                    title: const Text(
                      'Notifications push',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Activer ou désactiver les notifications push.',
                      style: TextStyle(color: Colors.white60),
                    ),
                    value: appSettings.pushNotificationsEnabled,
                    onChanged: appSettings.setPushNotificationsEnabled,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Envoie une notification de test pour vérifier que '
                        'les notifications Windows fonctionnent correctement.',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _testingNotification ? null : _testNotification,
                        icon: _testingNotification
                            ? const SizedBox(
                                width: 14, height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white70),
                              )
                            : const Icon(Icons.notifications_outlined, size: 16),
                        label: Text(_testingNotification
                            ? 'Envoi…'
                            : 'Tester la notification'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Données',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      _buildExportRow(
                        title: 'Exporter les concerts',
                        subtitle: 'Télécharger tous vos concerts au format CSV.',
                        loading: _exportingConcerts,
                        onPressed: _exportConcerts,
                      ),
                      const Divider(color: Color(0xFF2A2A3C), height: 28),
                      _buildExportRow(
                        title: 'Exporter les artistes',
                        subtitle: 'Télécharger tous vos artistes au format CSV.',
                        loading: _exportingArtistes,
                        onPressed: _exportArtistes,
                      ),
                      const Divider(color: Color(0xFF2A2A3C), height: 28),
                      _buildExportRow(
                        title: 'Exporter les lieux',
                        subtitle: 'Télécharger tous vos lieux au format CSV.',
                        loading: _exportingLieux,
                        onPressed: _exportLieux,
                      ),
                    ],
                  ),
                ),
                if (Platform.isWindows) ...[
                  const SizedBox(height: 20),
                  _buildCard(
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: const Color(0xFFFF6B35),
                      title: const Text(
                        'Démarrage automatique',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Lancer Concertothèque automatiquement au démarrage de Windows.',
                        style: TextStyle(color: Colors.white60),
                      ),
                      value: _autostartEnabled ?? false,
                      onChanged: _autostartEnabled == null
                          ? null
                          : (v) async {
                              await AutostartService.setEnabled(v);
                              if (mounted) setState(() => _autostartEnabled = v);
                            },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildExportRow({
    required String title,
    required String subtitle,
    required bool loading,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 140,
          child: ElevatedButton.icon(
            onPressed: loading ? null : onPressed,
            icon: loading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white70),
                  )
                : const Icon(Icons.download_outlined, size: 16),
            label: Text(loading ? 'Export...' : 'Exporter CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2A3C),
              foregroundColor: Colors.white70,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF3A3A4C))),
              textStyle: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showEditProfileDialog(BuildContext context, User? user) async {
    final TextEditingController nameController = TextEditingController(
      text: user?.displayName ?? '',
    );

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text(
            'Modifier le profil',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nom affiché',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF12121A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Enregistrer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldSave == true && user != null) {
      await user.updateDisplayName(nameController.text.trim());
      await user.reload();
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour.')),
        );
      }
    }

    nameController.dispose();
  }
}
