import 'package:flutter/material.dart';
import '../models/lieu.dart';
import '../services/lieu_service.dart';
import '../widgets/main_layout.dart';
import 'lieu_detail_screen.dart';
import 'lieu_edit_screen.dart';

class LieuxScreen extends StatefulWidget {
  const LieuxScreen({super.key});

  @override
  State<LieuxScreen> createState() => _LieuxScreenState();
}

class _LieuxScreenState extends State<LieuxScreen> {
  final _service          = LieuService();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  List<Lieu> _lieux   = [];
  bool       _loading = true;
  String?    _error;

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
      final lieux = await _service.fetchAll();
      if (mounted) setState(() { _lieux = lieux; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  List<Lieu> get _filtered {
    final q = _searchController.text.toLowerCase().trim();
    if (q.isEmpty) return _lieux;
    return _lieux.where((l) =>
        l.nom.toLowerCase().contains(q)   ||
        l.ville.toLowerCase().contains(q) ||
        l.type.toLowerCase().contains(q)).toList();
  }

  Future<void> _openEdit({Lieu? lieu}) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LieuEditScreen(lieu: lieu),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    if (result == true) await _loadAll();
  }

  Future<void> _delete(Lieu l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer le lieu',
            style: TextStyle(color: Colors.white)),
        content: Text('Voulez-vous vraiment supprimer "${l.nom}" ?',
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
      await _service.delete(l.id);
      await _loadAll();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;
    return MainLayout(
      currentRoute: 'lieux',
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(
                    color: Color(0xFFEF5350), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              const Text('Mes Lieux',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(
                '${_lieux.length} lieu${_lieux.length > 1 ? 'x' : ''}',
                style: const TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ]),
            const SizedBox(height: 24),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Rechercher un lieu…',
                hintStyle:
                    const TextStyle(color: Colors.white38, fontSize: 14),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white38, size: 20),
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
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<Lieu> rows) {
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
            const SizedBox(height: 12),
            const Text('Impossible de charger les lieux.',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _loadAll,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    if (rows.isEmpty) {
      return Center(
        child: Text(
          _lieux.isEmpty
              ? 'Aucun lieu.\nCliquez sur Ajouter pour commencer.'
              : 'Aucun résultat pour "${_searchController.text}".',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white38, fontSize: 14),
        ),
      );
    }
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: rows.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (_, i) => _buildCard(rows[i]),
      ),
    );
  }

  void _openDetail(Lieu l) => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LieuDetailScreen(lieu: l),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ).then((_) => _loadAll());

  Widget _buildCard(Lieu l) {
    return InkWell(
      onTap: () => _openDetail(l),
      borderRadius: BorderRadius.circular(10),
      child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 48, height: 48,
            child: l.photo.isNotEmpty
                ? Image.network(l.photo,
                    width: 48, height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarFallback(l.nom))
                : _avatarFallback(l.nom),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.nom,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Row(children: [
                if (l.ville.isNotEmpty)
                  Text('${l.ville}, ${l.pays}',
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12)),
                if (l.type.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF5350).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(l.type,
                        style: const TextStyle(
                            color: Color(0xFFEF5350), fontSize: 11)),
                  ),
                ],
              ]),
            ],
          ),
        ),
        if (l.capacite > 0)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${l.capacite}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const Text('places',
                    style: TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        _actionBtn('Modifier', const Color(0xFF1976D2),
            () => _openEdit(lieu: l)),
        const SizedBox(width: 8),
        _actionBtn('Supprimer', const Color(0xFFD32F2F), () => _delete(l)),
      ]),
    ),  // Container
    );  // InkWell
  }

  Widget _avatarFallback(String nom) => Container(
    color: const Color(0xFF2A2A3C),
    alignment: Alignment.center,
    child: Text(
      nom.isNotEmpty ? nom[0].toUpperCase() : '?',
      style: const TextStyle(
          color: Color(0xFFEF5350),
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
