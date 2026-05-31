import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/artiste.dart';
import '../services/artiste_service.dart';
import '../widgets/main_layout.dart';
import 'artiste_detail_screen.dart';
import 'artiste_edit_screen.dart';

class ArtistesScreen extends StatefulWidget {
  const ArtistesScreen({super.key});

  @override
  State<ArtistesScreen> createState() => _ArtistesScreenState();
}

class _ArtistesScreenState extends State<ArtistesScreen> {
  final _service = ArtisteService();
  final _searchController = TextEditingController();

  List<Artiste> _pageItems = [];
  bool _loading = true;
  String? _error;
  bool _hasMore = false;
  int _currentPage = 0;
  final _cursors = <QueryDocumentSnapshot<Map<String, dynamic>>?>[null];

  @override
  void initState() {
    super.initState();
    _loadPage(0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPage(int page) async {
    setState(() { _loading = true; _error = null; });
    try {
      final cursor = page < _cursors.length ? _cursors[page] : null;
      final result = await _service.fetchPage(cursor: cursor);

      if (result.hasMore && result.lastDoc != null) {
        final next = page + 1;
        if (next >= _cursors.length) {
          _cursors.add(result.lastDoc);
        } else {
          _cursors[next] = result.lastDoc;
        }
      }

      if (mounted) {
        setState(() {
          _pageItems = result.items;
          _hasMore = result.hasMore;
          _currentPage = page;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _reloadCurrentPage() => _loadPage(_currentPage);

  List<Artiste> get _filtered {
    final q = _searchController.text.toLowerCase().trim();
    if (q.isEmpty) return _pageItems;
    return _pageItems
        .where((a) =>
            a.nom.toLowerCase().contains(q) ||
            a.genre.toLowerCase().contains(q))
        .toList();
  }

  // ─── Navigation édition ───────────────────────────────────────────────────

  Future<void> _openEdit({Artiste? artiste}) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ArtisteEditScreen(artiste: artiste),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    if (result == true) await _reloadCurrentPage();
  }

  Future<void> _deleteArtiste(Artiste a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer l\'artiste',
            style: TextStyle(color: Colors.white)),
        content: Text('Voulez-vous vraiment supprimer "${a.nom}" ?',
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
      await _service.delete(a.id);
      await _reloadCurrentPage();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;
    return MainLayout(
      currentRoute: 'artistes',
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
              const Text('Mes Artistes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${_pageItems.length} artiste${_pageItems.length > 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.white38, fontSize: 14)),
            ]),
            const SizedBox(height: 24),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Rechercher un artiste...',
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
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(child: _buildBody(rows)),
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
                  _buildPaginationBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationBar() {
    final start = _currentPage * ArtisteService.pageSize + 1;
    final end   = start + _pageItems.length - 1;
    final label = _pageItems.isEmpty ? '' : '$start – $end';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF2A2A3C), width: 0.5)),
        color: Color(0xFF1A1A26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            color: _currentPage > 0 ? Colors.white70 : Colors.white24,
            splashRadius: 18,
            onPressed: _currentPage > 0 && !_loading
                ? () => _loadPage(_currentPage - 1)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label.isEmpty
                  ? 'Page ${_currentPage + 1}'
                  : '${_currentPage + 1}  ·  $label',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            color: _hasMore ? Colors.white70 : Colors.white24,
            splashRadius: 18,
            onPressed: _hasMore && !_loading
                ? () => _loadPage(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(List<Artiste> rows) {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6B35)));
    }
    if (_error != null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                color: Colors.white30, size: 48),
            SizedBox(height: 12),
            Text('Impossible de charger les artistes.',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 6),
            Text('Vérifiez les règles Firestore.',
                style: TextStyle(color: Colors.white38, fontSize: 13)),
          ],
        ),
      );
    }
    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, color: Colors.white24, size: 48),
            const SizedBox(height: 12),
            Text(
              _pageItems.isEmpty
                  ? 'Aucun artiste.\nLancez migrate-artistes.js pour importer les données.'
                  : 'Aucun résultat pour "${_searchController.text}".',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      );
    }
    return Scrollbar(
      child: ListView.builder(
        itemCount: rows.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (_, i) => _buildCard(rows[i]),
      ),
    );
  }

  void _openDetail(Artiste a) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ArtisteDetailScreen(artiste: a),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Widget _buildCard(Artiste a) {
    return InkWell(
      onTap: () => _openDetail(a),
      borderRadius: BorderRadius.circular(10),
      child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _avatar(a),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.nom,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                if (a.genre.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(a.genre,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ),
              ],
            ),
          ),
          _actionBtn('Modifier', const Color(0xFF1976D2),
              () => _openEdit(artiste: a)),
          const SizedBox(width: 8),
          _actionBtn('Supprimer', const Color(0xFFD32F2F),
              () => _deleteArtiste(a)),
        ],
      ),
    ),  // Container
    );  // InkWell
  }

  Widget _avatar(Artiste a) {
    return ClipOval(
      child: SizedBox(
        width: 48, height: 48,
        child: a.photo.isNotEmpty
            ? Image.network(a.photo,
                width: 48, height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _avatarFallback(a.nom))
            : _avatarFallback(a.nom),
      ),
    );
  }

  Widget _avatarFallback(String nom) => Container(
        color: const Color(0xFF2A2A3C),
        alignment: Alignment.center,
        child: Text(
          nom.isNotEmpty ? nom[0].toUpperCase() : '?',
          style: const TextStyle(
              color: Color(0xFFFF6B35),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      );

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

}
