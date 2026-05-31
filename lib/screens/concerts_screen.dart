import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../services/evenement_service.dart';
import '../widgets/main_layout.dart';
import 'concert_detail_screen.dart';
import 'evenement_edit_screen.dart';

class ConcertsScreen extends StatefulWidget {
  const ConcertsScreen({super.key});

  @override
  State<ConcertsScreen> createState() => _ConcertsScreenState();
}

class _ConcertsScreenState extends State<ConcertsScreen> {
  final _service = EvenementService();
  final _searchController = TextEditingController();

  String _filterType = 'Tous';
  String _sortColumn = 'date';
  bool _sortAscending = false;
  final _selectedIds = <String>{};
  final _scrollController = ScrollController();

  List<Evenement> _allConcerts = [];
  bool _loading = true;
  String? _error;

  static const _filterOptions = [
    ('Tous', 'Tous'),
    ('CON',  'Concert'),
    ('FES',  'Festival'),
    ('SOI',  'Soirée'),
    ('SHO',  'Showcase'),
    ('COM',  'Comédie'),
  ];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() { _loading = true; _error = null; });
    try {
      final concerts = await _service.fetchAll();
      if (mounted) setState(() { _allConcerts = concerts; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  // ─── Données filtrées + triées ────────────────────────────────────────────

  List<Evenement> get _filtered {
    final q = _searchController.text.toLowerCase().trim();
    final list = _allConcerts.where((e) {
      if (q.isNotEmpty) {
        final hit = e.nomEvent.toLowerCase().contains(q) ||
            e.ville.toLowerCase().contains(q) ||
            e.artistes.any((a) => a.toLowerCase().contains(q));
        if (!hit) return false;
      }
      if (_filterType != 'Tous' && e.typeCode != _filterType) return false;
      return true;
    }).toList();

    list.sort((a, b) {
      int cmp = 0;
      switch (_sortColumn) {
        case 'titre':   cmp = a.nomEvent.compareTo(b.nomEvent); break;
        case 'date':    cmp = a.date.compareTo(b.date); break;
        case 'ville':   cmp = a.ville.compareTo(b.ville); break;
        case 'status':  cmp = (a.isArchive ? 1 : 0).compareTo(b.isArchive ? 1 : 0); break;
        case 'type':    cmp = a.typeCode.compareTo(b.typeCode); break;
        case 'artistes':cmp = a.artistes.join().compareTo(b.artistes.join()); break;
      }
      return _sortAscending ? cmp : -cmp;
    });
    return list;
  }

  bool get _allSelected {
    final f = _filtered;
    return f.isNotEmpty && f.every((e) => _selectedIds.contains(e.id));
  }

  bool get _someSelected =>
      _filtered.any((e) => _selectedIds.contains(e.id)) && !_allSelected;

  // ─── Actions ──────────────────────────────────────────────────────────────

  void _onSort(String col) => setState(() {
    if (_sortColumn == col) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = col;
      _sortAscending = true;
    }
  });

  void _toggleAll() => setState(() {
    if (_allSelected) {
      for (final e in _filtered) { _selectedIds.remove(e.id); }
    } else {
      for (final e in _filtered) { _selectedIds.add(e.id); }
    }
  });

  String _formatDate(DateTime d) {
    const months = [
      'janvier','février','mars','avril','mai','juin',
      'juillet','août','septembre','octobre','novembre','décembre',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  // ─── Navigation édition ───────────────────────────────────────────────────

  Future<void> _openEdit({Evenement? evenement}) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EvenementEditScreen(evenement: evenement),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    if (result == true) await _loadAll();
  }

  Future<void> _deleteEvenement(Evenement e) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Supprimer l'événement",
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Voulez-vous vraiment supprimer "${e.nomEvent}" ?',
          style: const TextStyle(color: Colors.white70),
        ),
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
      await _service.delete(e.id);
      _selectedIds.remove(e.id);
      await _loadAll();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;
    return MainLayout(
      currentRoute: 'concerts',
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              const Text('Mes Concerts',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Rechercher concert, artiste, ville...',
                    hintStyle:
                        const TextStyle(color: Colors.white38, fontSize: 14),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.white38, size: 20),
                    filled: true,
                    fillColor: const Color(0xFF1E1E2C),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterButtons(),
            ]),
            const SizedBox(height: 20),
            // Stack à l'intérieur de Expanded — contraintes toujours bornées
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(children: [
                        _buildTableHeader(),
                        Expanded(child: _buildBody(rows)),
                      ]),
                    ),
                  ),
                  Positioned(
                    bottom: 20, right: 20,
                    child: FloatingActionButton.extended(
                      onPressed: () => _openEdit(),
                      backgroundColor: const Color(0xFFFF6B35),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Ajouter',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<Evenement> rows) {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6B35)));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined,
                color: Colors.white30, size: 48),
            const SizedBox(height: 16),
            const Text('Impossible de charger les données.',
                style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 6),
            const Text('Vérifiez les règles Firestore.',
                style: TextStyle(color: Colors.white38, fontSize: 13)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _loadAll(),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (rows.isEmpty) {
      return const Center(
          child: Text('Aucun événement trouvé.',
              style: TextStyle(color: Colors.white54, fontSize: 15)));
    }
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: rows.length,
        itemBuilder: (_, i) => _buildRow(rows[i], i),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterOptions.map((opt) {
          final (code, label) = opt;
          final isActive = _filterType == code;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive
                    ? const Color(0xFFFF6B35)
                    : const Color(0xFF1E1E2C),
                foregroundColor: isActive ? Colors.white : Colors.white54,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: isActive
                      ? BorderSide.none
                      : const BorderSide(color: Color(0xFF3A3A4C)),
                ),
              ),
              onPressed: () => setState(() => _filterType = code),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFFF6B35),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        SizedBox(
          width: 42,
          child: Checkbox(
            value: _someSelected ? null : _allSelected,
            tristate: true,
            onChanged: (_) => _toggleAll(),
            activeColor: Colors.white,
            checkColor: const Color(0xFFFF6B35),
            side: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        _headerCell('Titre',    'titre',    flex: 3),
        _headerCell('Date',     'date',     width: 120),
        _headerCell('Ville',    'ville',    width: 100),
        _headerCell('Status',   'status',   width: 110),
        _headerCell('Type',     'type',     width: 110),
        _headerCell('Artistes', 'artistes', flex: 2),
        const SizedBox(width: 176),
      ]),
    );
  }

  Widget _headerCell(String label, String col, {double? width, int? flex}) {
    final isActive = _sortColumn == col;
    final icon =
        (_sortAscending || !isActive) ? Icons.arrow_upward : Icons.arrow_downward;

    Widget cell = InkWell(
      onTap: () => _onSort(col),
      hoverColor: Colors.white12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13,
                color: isActive ? Colors.white : Colors.white60),
            const SizedBox(width: 4),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  )),
            ),
          ],
        ),
      ),
    );

    if (width != null) return SizedBox(width: width, child: cell);
    if (flex != null) return Expanded(flex: flex, child: cell);
    return cell;
  }

  Widget _buildRow(Evenement e, int index) {
    final isSelected = _selectedIds.contains(e.id);
    final rowColor = isSelected
        ? const Color(0xFFFF6B35).withValues(alpha: 0.09)
        : (index % 2 == 0
            ? const Color(0xFF1E1E2C)
            : const Color(0xFF191926));

    return Material(
      color: rowColor,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ConcertDetailScreen(evenement: e),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        ),
        hoverColor: const Color(0xFFFF6B35).withValues(alpha: 0.05),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xFF2A2A3C), width: 0.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            SizedBox(
              width: 42,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => setState(() {
                  if (isSelected) {
                    _selectedIds.remove(e.id);
                  } else {
                    _selectedIds.add(e.id);
                  }
                }),
                activeColor: const Color(0xFFFF6B35),
                side: const BorderSide(color: Colors.white38, width: 1.5),
              ),
            ),
            Expanded(
              flex: 3,
              child: Tooltip(
                message: e.nomEvent,
                child: Text(e.nomEvent,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(_formatDate(e.date),
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            SizedBox(
              width: 100,
              child: Tooltip(
                message: '${e.ville}, ${e.pays}',
                child: Text(e.ville,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            SizedBox(
              width: 110,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildStatusBadge(e.isArchive)),
            ),
            SizedBox(
              width: 110,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildTypeBadge(e.type)),
            ),
            Expanded(
              flex: 2,
              child: Tooltip(
                message: e.artistes.isEmpty ? '' : e.artistes.join(', '),
                child: Text(
                  e.artistes.length > 2
                      ? '${e.artistes.take(2).join(', ')}, ...'
                      : e.artistes.join(', '),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              width: 176,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _actionBtn('Modifier', const Color(0xFF1976D2),
                      () => _openEdit(evenement: e)),
                  const SizedBox(width: 8),
                  _actionBtn('Supprimer', const Color(0xFFD32F2F),
                      () => _deleteEvenement(e)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _actionBtn(String label, Color color, VoidCallback onPressed) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(82, 32),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        child: Text(label),
      );

  Widget _buildStatusBadge(bool isArchive) {
    final color =
        isArchive ? const Color(0xFFFF9800) : const Color(0xFF26C6DA);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isArchive ? 'Archivé' : 'En cours',
        style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTypeBadge(ConcertType type) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          type.label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      );
}
