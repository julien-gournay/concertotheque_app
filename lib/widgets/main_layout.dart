import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/about_screen.dart';
import '../screens/artistes_screen.dart';
import '../screens/concerts_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/lieux_screen.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';
import '../services/inbox_service.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout(
      {super.key, required this.child, required this.currentRoute});

  static const double _kMobileBreakpoint = 720;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color shellBackground =
        isDark ? const Color(0xFF12121A) : const Color(0xFFF4F6FA);
    final Color sidebarBackground =
        isDark ? const Color(0xFF1E1E2C).withOpacity(0.5) : Colors.white;
    final Color primaryText = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color secondaryText = isDark ? Colors.white60 : Colors.black54;
    final Color userCardBackground =
        isDark ? const Color(0xFF1E1E2C) : const Color(0xFFEDEFF5);

    final bool isMobile =
        MediaQuery.of(context).size.width < _kMobileBreakpoint;

    if (isMobile) {
      return Scaffold(
        backgroundColor: shellBackground,
        appBar: AppBar(
          backgroundColor: sidebarBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryText),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.music_note,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Concertothèque",
                style: TextStyle(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: sidebarBackground,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildMenuContent(
                context,
                primaryText: primaryText,
                secondaryText: secondaryText,
                userCardBackground: userCardBackground,
              ),
            ),
          ),
        ),
        body: child,
      );
    }

    // Desktop / tablette : sidebar permanente
    return Scaffold(
      backgroundColor: shellBackground,
      body: Row(
        children: [
          Container(
            width: 250,
            color: sidebarBackground,
            padding: const EdgeInsets.all(24),
            child: _buildMenuContent(
              context,
              primaryText: primaryText,
              secondaryText: secondaryText,
              userCardBackground: userCardBackground,
              showHeader: true,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMenuContent(
    BuildContext context, {
    required Color primaryText,
    required Color secondaryText,
    required Color userCardBackground,
    bool showHeader = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.music_note, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                "Concertothèque",
                style: TextStyle(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],

        _buildNavItem(context, Icons.dashboard_outlined, "Dashboard",
            "dashboard"),
        _buildNavItem(context, Icons.mic_external_on_outlined, "Concerts",
            "concerts"),
        _buildNavItem(
            context, Icons.person_outline, "Artistes", "artistes"),
        _buildNavItem(
            context, Icons.place_outlined, "Lieux", "lieux"),
        _buildNavItem(context, Icons.settings_outlined, "Paramètres",
            "settings"),
        _buildNavItem(
            context, Icons.info_outline, "À propos", "about"),

        const Spacer(),

        // Profil Utilisateur en bas
        InkWell(
          onTap: () => _showUserDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: userCardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFFF6B35),
                  child: Text(
                    _initialFromEmail(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentEmail(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Appuyer pour se déconnecter",
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    String routeKey,
  ) {
    final bool isActive = currentRoute == routeKey;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color labelColor = isActive
        ? (isDark ? Colors.white : const Color(0xFF12121A))
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFFF6B35).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? const Border(
                left: BorderSide(color: Color(0xFFFF6B35), width: 4))
            : null,
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isActive ? const Color(0xFFFF6B35) : Colors.grey),
        title:
            Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
        onTap: () => _navigateTo(context, routeKey),
      ),
    );
  }

  String _currentEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? 'Utilisateur inconnu';
  }

  String _initialFromEmail() {
    final String email = _currentEmail();
    if (email.isEmpty) return '?';
    return email.substring(0, 1).toUpperCase();
  }

  void _navigateTo(BuildContext context, String routeKey) {
    if (routeKey == currentRoute) return;

    switch (routeKey) {
      case 'dashboard':
        _replaceWithoutTransition(context, const DashboardScreen());
        break;
      case 'concerts':
        _replaceWithoutTransition(context, const ConcertsScreen());
        break;
      case 'artistes':
        _replaceWithoutTransition(context, const ArtistesScreen());
        break;
      case 'lieux':
        _replaceWithoutTransition(context, const LieuxScreen());
        break;
      case 'about':
        _replaceWithoutTransition(context, const AboutScreen());
        break;
      case 'settings':
        _replaceWithoutTransition(context, const SettingsScreen());
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cette page sera disponible prochainement.'),
          ),
        );
    }
  }

  void _replaceWithoutTransition(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _showUserDialog(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Compte utilisateur',
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          _currentEmail(),
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Se déconnecter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    InboxService.stop();
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
