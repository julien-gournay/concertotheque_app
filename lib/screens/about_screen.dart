import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/main_layout.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: 'about',
      child: FutureBuilder<PackageInfo>(
        future: _packageInfoFuture,
        builder: (context, snapshot) {
          final String version = snapshot.hasData
              ? '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
              : '...';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• À propos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                _buildCard(
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.music_video,
                          color: Color(0xFFFF6B35),
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Concertothèque',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Version $version',
                            style: const TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Gérez et revivez vos expériences de concerts.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                _buildSectionTitle('Description'),
                _buildCard(
                  child: const Text(
                    'Concertothèque est une application desktop pour gérer votre collection de concerts. Ajoutez, modifiez et retrouvez tous les concerts avec notes, commentaires et affiches.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ),
                _buildSectionTitle('Développeur'),
                _buildCard(
                  child: const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 25,
                      child: Text('J'),
                    ),
                    title: Text(
                      'Julien Gournay',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Étudiant développeur - Passionné de musique',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Technologies'),
                          _buildCard(
                            child: const Text(
                              'Firebase\nFlutter\nFlutter Desktop',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Liens utiles'),
                          _buildCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLinkItem(
                                  context,
                                  label: 'GitHub',
                                  url: 'https://github.com',
                                ),
                                _buildLinkItem(
                                  context,
                                  label: 'Documentation Flutter',
                                  url: 'https://docs.flutter.dev',
                                ),
                                _buildLinkItem(
                                  context,
                                  label: 'Signaler un bug',
                                  url: 'https://github.com/issues',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    '© 2026 Julien Gournay — Concertothèque v$version',
                    style: const TextStyle(color: Colors.white24, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );

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

  Widget _buildLinkItem(
    BuildContext context, {
    required String label,
    required String url,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
      onPressed: () => _launchUrl(context, url),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFFB199),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    final bool launched =
        await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible d\'ouvrir: $url'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
