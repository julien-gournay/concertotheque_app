import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_settings.dart';
import '../services/artiste_service.dart';
import '../services/autostart_service.dart';
import '../services/evenement_service.dart';
import '../services/export_service.dart';
import '../services/inbox_service.dart';
import '../services/lieu_service.dart';
import '../services/notification_service.dart';
import '../widgets/main_layout.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  bool? _autostartEnabled;
  bool _exportingConcerts = false;
  bool _exportingArtistes = false;
  bool _exportingLieux = false;
  bool _testingNotification = false;
  bool? _osNotifGranted;
  bool _deletingAccount = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      AutostartService.isEnabled().then((v) {
        if (mounted) setState(() => _autostartEnabled = v);
      });
    }
    _checkOsNotifPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkOsNotifPermission();
  }

  Future<void> _checkOsNotifPermission() async {
    final granted = await NotificationService.isOsPermissionGranted();
    if (mounted) setState(() => _osNotifGranted = granted);
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

  Future<void> _testNotification() async {
    setState(() => _testingNotification = true);
    try {
      await InboxService.showLocal(
        title: 'Concertothèque — Test ✓',
        body: 'Les notifications Windows fonctionnent correctement.',
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

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Color(0xFFD32F2F), size: 24),
            SizedBox(width: 8),
            Text('Supprimer le compte',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Cette action est irréversible.\n\n'
          'Votre compte sera définitivement supprimé. '
          'Vos données (concerts, artistes, lieux) seront effacées.',
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer mon compte',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _deleteAccount();
  }

  Future<void> _deleteAccount() async {
    setState(() => _deletingAccount = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await user.delete();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'requires-recent-login') {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2C),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Reconnexion requise',
                style: TextStyle(color: Colors.white)),
            content: const Text(
              'Pour supprimer votre compte, vous devez vous reconnecter. '
              'Vous allez être déconnecté — reconnectez-vous puis réessayez.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35)),
                onPressed: () => Navigator.pop(ctx),
                child:
                    const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur : ${e.message}'),
          backgroundColor: const Color(0xFFD32F2F),
          duration: const Duration(seconds: 5),
        ));
      }
    } finally {
      if (mounted) setState(() => _deletingAccount = false);
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

                // ── Profil ────────────────────────────────────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Profil'),
                      const SizedBox(height: 12),
                      Text('Nom: $displayName',
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text('Email: $email',
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _showEditProfileDialog(context, user),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Modifier le profil',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Apparence ─────────────────────────────────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Apparence'),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<ThemeMode>(
                        initialValue: appSettings.themeMode,
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
                              child: Text('Suivre le système')),
                          DropdownMenuItem(
                              value: ThemeMode.light, child: Text('Clair')),
                          DropdownMenuItem(
                              value: ThemeMode.dark, child: Text('Sombre')),
                        ],
                        onChanged: (ThemeMode? mode) {
                          if (mode != null) appSettings.setThemeMode(mode);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Notifications ─────────────────────────────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Notifications'),
                      const SizedBox(height: 8),
                      _buildNotificationsSwitch(),
                      const Divider(color: Color(0xFF2A2A3C), height: 28),
                      ElevatedButton.icon(
                        onPressed:
                            _testingNotification ? null : _testNotification,
                        icon: _testingNotification
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white70),
                              )
                            : const Icon(Icons.notifications_outlined,
                                size: 16),
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

                // ── Données ───────────────────────────────────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Données'),
                      const SizedBox(height: 16),
                      _buildExportRow(
                        title: 'Exporter les concerts',
                        subtitle:
                            'Télécharger tous vos concerts au format CSV.',
                        loading: _exportingConcerts,
                        onPressed: _exportConcerts,
                      ),
                      const Divider(color: Color(0xFF2A2A3C), height: 28),
                      _buildExportRow(
                        title: 'Exporter les artistes',
                        subtitle:
                            'Télécharger tous vos artistes au format CSV.',
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
                      const Divider(color: Color(0xFF3D1A1A), height: 28),
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Supprimer définitivement le compte',
                                  style: TextStyle(
                                      color: Color(0xFFEF9A9A),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Cette action est irréversible et supprime toutes vos données.',
                                  style: TextStyle(
                                      color: Colors.white38, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 140,
                            child: ElevatedButton.icon(
                              onPressed: _deletingAccount
                                  ? null
                                  : _showDeleteAccountDialog,
                              icon: _deletingAccount
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white70),
                                    )
                                  : const Icon(
                                      Icons.delete_forever_outlined,
                                      size: 16),
                              label: Text(_deletingAccount
                                  ? 'Suppression…'
                                  : 'Supprimer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3D1C1C),
                                foregroundColor: const Color(0xFFEF9A9A),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: Color(0xFF7A2A2A)),
                                ),
                                textStyle: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Système (Windows) ─────────────────────────────────────────
                if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) ...[
                  const SizedBox(height: 20),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Système'),
                        const SizedBox(height: 8),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: const Color(0xFFFF6B35),
                          title: const Text('Démarrage automatique',
                              style: TextStyle(color: Colors.white)),
                          subtitle: const Text(
                            'Lancer Concertothèque automatiquement au démarrage de Windows.',
                            style: TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                          value: _autostartEnabled ?? false,
                          onChanged: _autostartEnabled == null
                              ? null
                              : (v) async {
                                  await AutostartService.setEnabled(v);
                                  if (mounted) {
                                    setState(() => _autostartEnabled = v);
                                  }
                                },
                        ),
                        const Divider(color: Color(0xFF2A2A3C), height: 28),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: const Color(0xFFFF6B35),
                          title: const Text('Réduire en arrière-plan',
                              style: TextStyle(color: Colors.white)),
                          subtitle: const Text(
                            'Lors de la fermeture, maintenir l’application exécutée.',
                            style: TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                          value: appSettings.minimizeToTray,
                          onChanged: appSettings.setMinimizeToTray,
                        ),
                      ],
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

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      );

  Widget _buildNotificationsSwitch() {
    final osGranted = _osNotifGranted ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: const Color(0xFFFF6B35),
          title: const Text('Activer les notifications',
              style: TextStyle(color: Colors.white)),
          subtitle: Text(
            _osNotifGranted == null
                ? 'Vérification des permissions…'
                : osGranted
                    ? 'Notifications autorisées par le système.'
                    : 'Notifications bloquées dans les paramètres système.',
            style: TextStyle(
              color: _osNotifGranted == false
                  ? const Color(0xFFFFB74D)
                  : Colors.white60,
              fontSize: 13,
            ),
          ),
          value: osGranted && appSettings.pushNotificationsEnabled,
          onChanged: (osGranted && _osNotifGranted != null)
              ? appSettings.setPushNotificationsEnabled
              : null,
        ),
        if (_osNotifGranted == false && !kIsWeb && defaultTargetPlatform == TargetPlatform.windows)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: TextButton.icon(
              onPressed: () =>
                  launchUrl(Uri.parse('ms-settings:notifications')),
              icon: const Icon(Icons.open_in_new,
                  size: 13, color: Color(0xFF64B5F6)),
              label: const Text(
                'Modifier dans les paramètres Windows',
                style:
                    TextStyle(color: Color(0xFF64B5F6), fontSize: 12),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        if (_osNotifGranted == false && (kIsWeb || defaultTargetPlatform != TargetPlatform.windows))
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Text(
              'Activez les notifications pour cette application dans les paramètres de votre appareil.',
              style: TextStyle(color: Color(0xFFFFB74D), fontSize: 12),
            ),
          ),
      ],
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
    final messenger = ScaffoldMessenger.of(context);

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text('Modifier le profil',
              style: TextStyle(color: Colors.white)),
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
                  backgroundColor: const Color(0xFFFF6B35)),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enregistrer',
                  style: TextStyle(color: Colors.white)),
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
        messenger.showSnackBar(
          const SnackBar(content: Text('Profil mis à jour.')),
        );
      }
    }

    nameController.dispose();
  }
}
