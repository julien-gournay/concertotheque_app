import 'package:flutter/material.dart';
import '../models/artiste.dart';
import '../models/concert.dart';
import '../services/evenement_service.dart';

class ArtisteDetailScreen extends StatefulWidget {
  final Artiste artiste;
  const ArtisteDetailScreen({super.key, required this.artiste});

  @override
  State<ArtisteDetailScreen> createState() => _ArtisteDetailScreenState();
}

class _ArtisteDetailScreenState extends State<ArtisteDetailScreen> {
  List<Evenement> _concerts = [];
  bool _loading = true;

  Artiste get _a => widget.artiste;

  @override
  void initState() {
    super.initState();
    _loadConcerts();
  }

  Future<void> _loadConcerts() async {
    final all = await EvenementService().fetchAll();
    if (!mounted) return;
    setState(() {
      _concerts = all
          .where((e) => e.artistes.contains(_a.nom))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _loading = false;
    });
  }

  String _formatDate(DateTime d) {
    const months = [
      'jan.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                tooltip: 'Retour',
              ),
              const SizedBox(width: 8),
              const Text('Détail artiste',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 32),
            // ── Carte artiste ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                // Photo
                ClipOval(
                  child: SizedBox(
                    width: 120, height: 120,
                    child: _a.photo.isNotEmpty
                        ? Image.network(
                            _a.photo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _avatarFallback(120),
                          )
                        : _avatarFallback(120),
                  ),
                ),
                const SizedBox(width: 32),
                // Infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_a.nom,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                      if (_a.genre.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFAB47BC).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFAB47BC).withValues(alpha: 0.4)),
                          ),
                          child: Text(_a.genre,
                              style: const TextStyle(
                                  color: Color(0xFFAB47BC), fontSize: 13)),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (!_loading)
                        Row(children: [
                          const Icon(Icons.music_note_outlined,
                              color: Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            '${_concerts.length} concert${_concerts.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 14),
                          ),
                        ]),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 32),
            // ── Concerts ─────────────────────────────────────────────────
            const Text('Concerts',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            if (_loading)
              const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF6B35)))
            else if (_concerts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(12)),
                child: const Text('Aucun concert enregistré pour cet artiste.',
                    style: TextStyle(color: Colors.white38, fontSize: 14)),
              )
            else
              ..._concerts.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _concertCard(e),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _concertCard(Evenement e) {
    final isArchive = e.isArchive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        // Affiche miniature
        if (e.affiche.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              e.affiche,
              width: 44, height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _eventPlaceholder(),
            ),
          )
        else
          _eventPlaceholder(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.nomEvent,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              [
                _formatDate(e.date),
                if (e.lieuNom.isNotEmpty) e.lieuNom,
                if (e.ville.isNotEmpty) e.ville,
              ].join(' · '),
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          _typeBadge(e.type),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(
                color: isArchive
                    ? const Color(0xFFFF9800)
                    : const Color(0xFF26C6DA),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isArchive ? 'Archivé' : 'À venir',
              style: TextStyle(
                color: isArchive
                    ? const Color(0xFFFF9800)
                    : const Color(0xFF26C6DA),
                fontSize: 11,
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _typeBadge(ConcertType type) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(type.label,
            style: const TextStyle(color: Colors.white, fontSize: 11)),
      );

  Widget _avatarFallback(double size) => Container(
        width: size, height: size,
        color: const Color(0xFF2A2A3C),
        alignment: Alignment.center,
        child: Text(
          _a.nom.isNotEmpty ? _a.nom[0].toUpperCase() : '?',
          style: TextStyle(
              color: const Color(0xFFFF6B35),
              fontWeight: FontWeight.bold,
              fontSize: size * 0.35),
        ),
      );

  Widget _eventPlaceholder() => Container(
        width: 44, height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A3C),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.music_note_outlined,
            color: Colors.white24, size: 20),
      );
}
