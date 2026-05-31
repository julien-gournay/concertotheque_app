import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../services/evenement_service.dart';
import '../widgets/main_layout.dart';
import 'concert_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Evenement>? _concerts;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final concerts = await EvenementService().fetchAll();
      if (mounted) setState(() { _concerts = concerts; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Stats concerts ────────────────────────────────────────────────────────
  int get _total    => _concerts?.length ?? 0;
  int get _upcoming => _concerts?.where((e) => !e.isArchive).length ?? 0;
  int get _archived => _concerts?.where((e) => e.isArchive).length ?? 0;
  double get _totalSpent =>
      _concerts?.fold(0.0, (s, e) => s! + e.prixBillet + e.depenseSup) ?? 0;

  // ── Stats artistes ────────────────────────────────────────────────────────
  int get _uniqueArtistes {
    final set = <String>{};
    for (final e in _concerts ?? []) { set.addAll(e.artistes); }
    return set.length;
  }

  List<MapEntry<String, int>> get _topArtistes {
    final freq = <String, int>{};
    for (final e in _concerts ?? []) {
      for (final a in e.artistes) { freq[a] = (freq[a] ?? 0) + 1; }
    }
    return (freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
        .take(5)
        .toList();
  }

  // ── Stats lieux ───────────────────────────────────────────────────────────
  int get _uniqueLieux {
    final set = <String>{};
    for (final e in _concerts ?? []) {
      final k = e.lieuNom.isNotEmpty ? '${e.lieuNom}|${e.ville}' : e.ville;
      if (k.isNotEmpty) set.add(k);
    }
    return set.length;
  }

  List<MapEntry<String, int>> get _topLieux {
    final freq = <String, int>{};
    for (final e in _concerts ?? []) {
      final k = e.lieuNom.isNotEmpty
          ? '${e.lieuNom}, ${e.ville}'
          : e.ville;
      if (k.isNotEmpty) freq[k] = (freq[k] ?? 0) + 1;
    }
    return (freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
        .take(5)
        .toList();
  }

  // ── Prochains concerts ────────────────────────────────────────────────────
  List<Evenement> get _futureConcerts {
    if (_concerts == null) return [];
    final now = DateTime.now();
    return (_concerts!
          .where((e) => !e.isArchive && e.date.isAfter(now))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date)));
  }

  String _formatDate(DateTime d) {
    const months = [
      'jan.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: 'dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tableau de bord',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 28),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
              )
            else ...[
              // ── Ligne 1 : stats concerts ──────────────────────────────
              Row(children: [
                Expanded(child: _statCard('Total concerts', '$_total',
                    Icons.music_note_outlined, const Color(0xFFFF6B35))),
                const SizedBox(width: 14),
                Expanded(child: _statCard('À venir', '$_upcoming',
                    Icons.upcoming_outlined, const Color(0xFF26C6DA))),
                const SizedBox(width: 14),
                Expanded(child: _statCard('Archivés', '$_archived',
                    Icons.archive_outlined, const Color(0xFFFF9800))),
                const SizedBox(width: 14),
                Expanded(child: _statCard('Total dépensé',
                    '${_totalSpent.toStringAsFixed(0)} €',
                    Icons.euro_outlined, const Color(0xFF66BB6A))),
              ]),
              const SizedBox(height: 14),
              // ── Ligne 2 : stats artistes + lieux ─────────────────────
              Row(children: [
                Expanded(child: _statCard('Artistes uniques', '$_uniqueArtistes',
                    Icons.person_outline, const Color(0xFFAB47BC))),
                const SizedBox(width: 14),
                Expanded(child: _statCard('Lieux visités', '$_uniqueLieux',
                    Icons.place_outlined, const Color(0xFFEF5350))),
                const SizedBox(width: 14),
                const Expanded(child: SizedBox()),
                const SizedBox(width: 14),
                const Expanded(child: SizedBox()),
              ]),
              const SizedBox(height: 32),
              // ── Top artistes + top lieux ──────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _topListCard(
                    title: 'Artistes les plus vus',
                    icon: Icons.person_outline,
                    color: const Color(0xFFAB47BC),
                    entries: _topArtistes,
                  )),
                  const SizedBox(width: 14),
                  Expanded(child: _topListCard(
                    title: 'Lieux les plus fréquentés',
                    icon: Icons.place_outlined,
                    color: const Color(0xFFEF5350),
                    entries: _topLieux,
                  )),
                ],
              ),
              const SizedBox(height: 32),
              // ── Prochains concerts ────────────────────────────────────
              const Text('Prochains concerts',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              if (_futureConcerts.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('Aucun concert à venir.',
                      style: TextStyle(color: Colors.white38, fontSize: 14)),
                )
              else
                ...(_futureConcerts.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _concertCard(e),
                    ))),
            ],
          ],
        ),
      ),
    );
  }

  // ── Widgets ───────────────────────────────────────────────────────────────

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ]),
      ]),
    );
  }

  Widget _topListCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<MapEntry<String, int>> entries,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ]),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Aucune donnée.',
                  style: TextStyle(color: Colors.white38, fontSize: 13)),
            )
          else ...[
            const SizedBox(height: 14),
            ...entries.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final name = entry.value.key;
              final count = entry.value.value;
              final maxCount = entries.first.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      SizedBox(
                        width: 18,
                        child: Text('$rank.',
                            style: TextStyle(
                                color: color.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                      ),
                      Text('$count×',
                          style: TextStyle(
                              color: color.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: count / maxCount,
                        minHeight: 3,
                        backgroundColor: const Color(0xFF2A2A3C),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _concertCard(Evenement e) {
    final daysLeft = e.date.difference(DateTime.now()).inDays;
    final isNext = _futureConcerts.first == e;

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.4), width: 1)
            : null,
      ),
      child: Row(children: [
        // Pastille date
        Container(
          width: 100,
          height: 52,
          decoration: BoxDecoration(
            color: isNext
                ? const Color(0xFFFF6B35).withValues(alpha: 0.35)
                : const Color(0xFF2A2A3C),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text('$daysLeft j.',
                style: TextStyle(
                    color: isNext
                        ? const Color(0xFFFF6B35)
                        : Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1)),
          ),
        ),
        const SizedBox(width: 16),
        // Infos
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
        if (e.artistes.isNotEmpty) ...[
          const SizedBox(width: 12),
          Text(
            e.artistes.length > 2
                ? '${e.artistes.take(2).join(', ')}…'
                : e.artistes.join(', '),
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ]),
    ),   // Container
    );   // InkWell
  }
}
