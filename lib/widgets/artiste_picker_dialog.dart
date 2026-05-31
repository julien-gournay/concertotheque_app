import 'dart:async';
import 'package:flutter/material.dart';
import '../models/artiste.dart';

/// Ouvre un dialog de sélection multi-artistes.
/// Retourne la liste des noms sélectionnés, ou null si annulé.
Future<List<String>?> showArtistePicker({
  required BuildContext context,
  required List<String> initialSelected,
  required Stream<List<Artiste>> stream,
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (_) => _ArtistePickerDialog(
      initialSelected: initialSelected,
      stream: stream,
    ),
  );
}

class _ArtistePickerDialog extends StatefulWidget {
  final List<String> initialSelected;
  final Stream<List<Artiste>> stream;

  const _ArtistePickerDialog({
    required this.initialSelected,
    required this.stream,
  });

  @override
  State<_ArtistePickerDialog> createState() => _ArtistePickerDialogState();
}

class _ArtistePickerDialogState extends State<_ArtistePickerDialog> {
  late List<String> _selected;
  String _search = '';
  List<Artiste> _all = [];
  StreamSubscription<List<Artiste>>? _sub;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
    _sub = widget.stream.listen(
      (data) => setState(() => _all = data),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  List<Artiste> get _filtered => _all
      .where((a) => a.nom.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.people_outline, color: Color(0xFFFF6B35), size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Sélectionner des artistes',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ),
          if (_selected.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${_selected.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      content: SizedBox(
        width: 480,
        height: 480,
        child: Column(
          children: [
            // Barre de recherche
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Rechercher un artiste...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search,
                    color: Colors.white38, size: 20),
                filled: true,
                fillColor: const Color(0xFF12121A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            // Liste
            Expanded(
              child: _all.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_add_outlined,
                              color: Colors.white24, size: 40),
                          SizedBox(height: 12),
                          Text(
                            'Aucun artiste.\nAjoutez-en depuis l\'onglet Artistes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white38, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : filtered.isEmpty
                      ? const Center(
                          child: Text('Aucun résultat.',
                              style: TextStyle(color: Colors.white38)),
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final a = filtered[i];
                            final isChecked = _selected.contains(a.nom);
                            return _ArtisteCheckTile(
                              artiste: a,
                              checked: isChecked,
                              onToggle: () => setState(() {
                                if (isChecked) {
                                  _selected.remove(a.nom);
                                } else {
                                  _selected.add(a.nom);
                                }
                              }),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Annuler',
              style: TextStyle(color: Colors.white60)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context, List.from(_selected)),
          child: Text(
            _selected.isEmpty
                ? 'Confirmer'
                : 'Confirmer (${_selected.length})',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _ArtisteCheckTile extends StatelessWidget {
  final Artiste artiste;
  final bool checked;
  final VoidCallback onToggle;

  const _ArtisteCheckTile({
    required this.artiste,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: checked,
              onChanged: (_) => onToggle(),
              activeColor: const Color(0xFFFF6B35),
              side: const BorderSide(color: Colors.white38, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 8),
            _avatar(artiste),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(artiste.nom,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  if (artiste.genre.isNotEmpty)
                    Text(artiste.genre,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(Artiste a) {
    return ClipOval(
      child: SizedBox(
        width: 36, height: 36,
        child: a.photo.isNotEmpty
            ? Image.network(a.photo,
                width: 36, height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(a.nom))
            : _fallback(a.nom),
      ),
    );
  }

  Widget _fallback(String nom) => Container(
        color: const Color(0xFF2A2A3C),
        alignment: Alignment.center,
        child: Text(
          nom.isNotEmpty ? nom[0].toUpperCase() : '?',
          style: const TextStyle(
              color: Color(0xFFFF6B35),
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
      );
}
