import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../models/lieu.dart';
import '../services/evenement_service.dart';
import '../services/lieu_service.dart';
import 'concert_detail_screen.dart';
import 'lieu_edit_screen.dart';

class LieuDetailScreen extends StatefulWidget {
  final Lieu lieu;
  const LieuDetailScreen({super.key, required this.lieu});

  @override
  State<LieuDetailScreen> createState() => _LieuDetailScreenState();
}

class _LieuDetailScreenState extends State<LieuDetailScreen> {
  final _service = LieuService();
  List<Evenement> _concerts = [];
  bool _loading = true;

  Lieu get _l => widget.lieu;

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
          .where((e) => e.lieuNom == _l.nom || e.ville == _l.ville && e.lieuNom == _l.nom)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _loading = false;
    });
  }

  Future<void> _openEdit() async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LieuEditScreen(lieu: _l),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    if (result == true && mounted) setState(() {});
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer le lieu',
            style: TextStyle(color: Colors.white)),
        content: Text('Voulez-vous vraiment supprimer "${_l.nom}" ?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler',
                style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _service.delete(_l.id);
      if (mounted) Navigator.pop(context, true);
    }
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
              const Text('Détail du lieu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B2B4A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF2A4A7A)),
                  ),
                  elevation: 0,
                ),
                onPressed: _openEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Modifier'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A1A1A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF7A2A2A)),
                  ),
                  elevation: 0,
                ),
                onPressed: _confirmDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Supprimer'),
              ),
            ]),
            const SizedBox(height: 24),
            // ── Carte principale ──────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo / avatar
                Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 220, height: 160,
                      child: _l.photo.isNotEmpty
                          ? Image.network(_l.photo,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _photoPlaceholder())
                          : _photoPlaceholder(),
                    ),
                  ),
                ]),
                const SizedBox(width: 24),
                // Infos
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2C),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(_l.nom,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            if (_l.type.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF5350)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFFEF5350)
                                          .withValues(alpha: 0.4)),
                                ),
                                child: Text(_l.type,
                                    style: const TextStyle(
                                        color: Color(0xFFEF5350),
                                        fontSize: 12)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _infoRow(Icons.location_on_outlined,
                            '${_l.ville}, ${_l.pays}'),
                        if (_l.adresse.isNotEmpty)
                          _infoRow(Icons.map_outlined, _l.adresse),
                        if (_l.capacite > 0)
                          _infoRow(Icons.people_outline,
                              '${_l.capacite} places'),
                        if (_l.siteWeb.isNotEmpty)
                          _infoRow(Icons.language_outlined, _l.siteWeb),
                        const SizedBox(height: 12),
                        if (!_loading)
                          Row(children: [
                            const Icon(Icons.music_note_outlined,
                                color: Colors.white38, size: 15),
                            const SizedBox(width: 6),
                            Text(
                              '${_concerts.length} concert${_concerts.length > 1 ? 's' : ''} enregistré${_concerts.length > 1 ? 's' : ''}',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 13),
                            ),
                          ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // ── Concerts dans ce lieu ─────────────────────────────────────
            const Text('Concerts dans ce lieu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            if (_loading)
              const Center(
                  child:
                      CircularProgressIndicator(color: Color(0xFFFF6B35)))
            else if (_concerts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                    'Aucun concert enregistré pour ce lieu.',
                    style:
                        TextStyle(color: Colors.white38, fontSize: 14)),
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

  Widget _infoRow(IconData icon, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon, size: 15, color: Colors.white38),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13)),
          ),
        ]),
      );

  Widget _photoPlaceholder() => Container(
        color: const Color(0xFF2A2A3C),
        alignment: Alignment.center,
        child: Text(
          _l.nom.isNotEmpty ? _l.nom[0].toUpperCase() : '?',
          style: const TextStyle(
              color: Color(0xFFEF5350),
              fontWeight: FontWeight.bold,
              fontSize: 48),
        ),
      );

  Widget _concertCard(Evenement e) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ConcertDetailScreen(evenement: e),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          if (e.affiche.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(e.affiche,
                  width: 44, height: 60, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _eventPlaceholder()),
            )
          else
            _eventPlaceholder(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.nomEvent,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(_formatDate(e.date),
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            _typeBadge(e.type),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: e.isArchive
                      ? const Color(0xFFFF9800)
                      : const Color(0xFF26C6DA),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                e.isArchive ? 'Archivé' : 'À venir',
                style: TextStyle(
                  color: e.isArchive
                      ? const Color(0xFFFF9800)
                      : const Color(0xFF26C6DA),
                  fontSize: 11,
                ),
              ),
            ),
          ]),
        ]),
      ),
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
