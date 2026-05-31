import 'package:flutter/material.dart';
import '../models/artiste.dart';
import '../models/concert.dart';
import '../models/lieu.dart';
import '../services/artiste_service.dart';
import '../services/evenement_service.dart';
import '../services/lieu_service.dart';
import '../widgets/main_layout.dart';
import 'artiste_detail_screen.dart';
import 'evenement_edit_screen.dart';
import 'lieu_detail_screen.dart';

class ConcertDetailScreen extends StatefulWidget {
  final Evenement evenement;
  const ConcertDetailScreen({super.key, required this.evenement});

  @override
  State<ConcertDetailScreen> createState() => _ConcertDetailScreenState();
}

class _ConcertDetailScreenState extends State<ConcertDetailScreen> {
  final _service = EvenementService();
  final _artisteService = ArtisteService();
  late Evenement _e;
  Map<String, Artiste> _artisteMap = {};
  Lieu? _matchedLieu;

  @override
  void initState() {
    super.initState();
    _e = widget.evenement;
    _loadArtistes();
    _loadLieu();
  }

  Future<void> _loadLieu() async {
    if (_e.lieuNom.isEmpty) return;
    try {
      final lieux = await LieuService().fetchAll();
      final match = lieux.firstWhere(
        (l) => l.nom == _e.lieuNom && l.ville == _e.ville,
        orElse: () => lieux.firstWhere(
          (l) => l.nom == _e.lieuNom,
          orElse: () => throw Exception('not found'),
        ),
      );
      if (mounted) setState(() => _matchedLieu = match);
    } catch (_) {}
  }

  Future<void> _loadArtistes() async {
    if (_e.artistes.isEmpty) return;
    final all = await _artisteService.fetchAll();
    final map = <String, Artiste>{};
    for (final a in all) {
      if (_e.artistes.contains(a.nom)) map[a.nom] = a;
    }
    if (mounted) setState(() => _artisteMap = map);
  }

  String _formatDate(DateTime d) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ─── Edition ──────────────────────────────────────────────────────────────

  Future<void> _openEdit() async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EvenementEditScreen(evenement: _e),
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
        title: const Text("Supprimer l'événement",
            style: TextStyle(color: Colors.white)),
        content: Text('Voulez-vous vraiment supprimer "${_e.nomEvent}" ?',
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
      await _service.delete(_e.id);
      if (mounted) Navigator.pop(context);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: 'concerts',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftPanel(),
                const SizedBox(width: 24),
                Expanded(child: _buildRightPanel()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.arrow_back_ios_new,
                color: Colors.white70, size: 18),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 10, height: 10,
          decoration: const BoxDecoration(
              color: Color(0xFFFF6B35), shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        const Text('Détail du concert',
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLeftPanel() {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: _e.affiche.isNotEmpty
                  ? Image.network(
                      _e.affiche,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return _imgPlaceholder(loading: true);
                      },
                      errorBuilder: (_, __, ___) => _imgPlaceholder(),
                    )
                  : _imgPlaceholder(),
            ),
          ),
          const SizedBox(height: 16),
          _sideBtn(
            icon: Icons.edit_outlined,
            label: 'Modifier',
            bg: const Color(0xFF1B2B4A),
            border: const Color(0xFF2A4A7A),
            onPressed: _openEdit,
          ),
          const SizedBox(height: 10),
          _sideBtn(
            icon: Icons.delete_outline,
            label: 'Supprimer',
            bg: const Color(0xFF3A1A1A),
            border: const Color(0xFF7A2A2A),
            onPressed: _confirmDelete,
          ),
        ],
      ),
    );
  }

  Widget _imgPlaceholder({bool loading = false}) => Container(
        color: const Color(0xFF2A2A3C),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(color: Color(0xFFFF6B35))
              : const Icon(Icons.image_not_supported_outlined,
                  color: Colors.white24, size: 48),
        ),
      );

  Widget _sideBtn({
    required IconData icon,
    required String label,
    required Color bg,
    required Color border,
    required VoidCallback onPressed,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: border),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  Widget _buildRightPanel() {
    final placementLabel = placementLabels[_e.placement] ?? _e.placement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Bannière cover ───────────────────────────────────────────────
        if (_e.cover.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _e.cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1E1E2C),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: Colors.white24, size: 40),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC12121A)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_e.cover.isNotEmpty) const SizedBox(height: 16),
        // ── Carte infos ──────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(_e.nomEvent,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  _typeBadge(_e.type),
                ],
              ),
              const SizedBox(height: 16),
              _row(Icons.calendar_today_outlined, 'Date', _formatDate(_e.date)),
              _sep(),
              _matchedLieu != null
                  ? _rowClickable(
                      Icons.place_outlined, 'Lieu',
                      _e.lieuNom.isEmpty ? '—' : _e.lieuNom,
                      () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              LieuDetailScreen(lieu: _matchedLieu!),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      ),
                    )
                  : _row(Icons.place_outlined, 'Lieu',
                      _e.lieuNom.isEmpty ? '—' : _e.lieuNom),
              _sep(),
              _row(Icons.location_city_outlined, 'Ville',
                  '${_e.ville}, ${_e.pays}'),
              _sep(),
              _row(Icons.confirmation_number_outlined, 'Placement',
                  placementLabel),
              if (_e.prixBillet > 0) ...[
                _sep(),
                _row(
                  Icons.euro_outlined,
                  'Prix billet',
                  '${_e.prixBillet.toStringAsFixed(2)} €'
                      '${_e.depenseSup > 0 ? '  (+${_e.depenseSup.toStringAsFixed(2)} € dép.)' : ''}',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Carte Line Up ────────────────────────────────────────────────
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 150),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Line Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              if (_e.artistes.isEmpty)
                const Center(
                  child: Text('Aucun artiste renseigné',
                      style: TextStyle(color: Colors.white38, fontSize: 14)),
                )
              else
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _e.artistes
                      .map((nom) => _artisteCard(nom, _artisteMap[nom]))
                      .toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _artisteCard(String nom, Artiste? artiste) {
    return InkWell(
      onTap: artiste == null ? null : () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ArtisteDetailScreen(artiste: artiste),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ),
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            ClipOval(
              child: SizedBox(
                width: 72,
                height: 72,
                child: artiste?.photo.isNotEmpty == true
                    ? Image.network(
                        artiste!.photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) =>
                            progress == null ? child : _avatarFallback(nom),
                        errorBuilder: (_, __, ___) => _avatarFallback(nom),
                      )
                    : _avatarFallback(nom),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              nom,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            if (artiste?.genre.isNotEmpty == true)
              Text(
                artiste!.genre,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
          ],
        ),
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
              fontSize: 26),
        ),
      );

  Widget _rowClickable(IconData icon, String label, String value,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Icon(icon, size: 16, color: const Color(0xFFFF6B35)),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(children: [
              Text(value,
                  style: const TextStyle(
                      color: Color(0xFFFF6B35), fontSize: 13)),
              const SizedBox(width: 6),
              const Icon(Icons.open_in_new,
                  size: 12, color: Color(0xFFFF6B35)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white54),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white54, fontSize: 13)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _sep() => const Divider(
      color: Color(0xFF2A2A3C), height: 1, thickness: 0.5);

  Widget _typeBadge(ConcertType type) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(type.label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      );
}
