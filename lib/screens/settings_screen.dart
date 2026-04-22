import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../widgets/main_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                    activeColor: const Color(0xFFFF6B35),
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
        color: const Color(0xFF1E1E2C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
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
