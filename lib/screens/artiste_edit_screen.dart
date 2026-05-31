import 'package:flutter/material.dart';
import '../models/artiste.dart';
import '../services/artiste_service.dart';

class ArtisteEditScreen extends StatefulWidget {
  final Artiste? artiste;
  const ArtisteEditScreen({super.key, this.artiste});

  @override
  State<ArtisteEditScreen> createState() => _ArtisteEditScreenState();
}

class _ArtisteEditScreenState extends State<ArtisteEditScreen> {
  final _service = ArtisteService();
  late final TextEditingController _nomCtrl;
  late final TextEditingController _genreCtrl;
  late final TextEditingController _photoCtrl;
  bool _saving = false;

  bool get _isEdit => widget.artiste != null;

  @override
  void initState() {
    super.initState();
    _nomCtrl   = TextEditingController(text: widget.artiste?.nom   ?? '');
    _genreCtrl = TextEditingController(text: widget.artiste?.genre ?? '');
    _photoCtrl = TextEditingController(text: widget.artiste?.photo ?? '');
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _genreCtrl.dispose();
    _photoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nom = _nomCtrl.text.trim();
    if (nom.isEmpty) return;
    setState(() => _saving = true);
    try {
      if (_isEdit) {
        widget.artiste!
          ..nom   = nom
          ..genre = _genreCtrl.text.trim()
          ..photo = _photoCtrl.text.trim();
        await _service.update(widget.artiste!);
      } else {
        await _service.add(Artiste(
          id:    '',
          nom:   nom,
          genre: _genreCtrl.text.trim(),
          photo: _photoCtrl.text.trim(),
        ));
      }
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
            Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                tooltip: 'Retour',
              ),
              const SizedBox(width: 8),
              Text(
                _isEdit ? "Modifier l'artiste" : 'Nouvel artiste',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (_saving)
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Color(0xFFFF6B35), strokeWidth: 2),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler',
                    style: TextStyle(color: Colors.white60)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _saving ? null : _save,
                child: Text(
                  _isEdit ? 'Enregistrer' : 'Ajouter',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ]),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field('Nom *', _nomCtrl),
                  const SizedBox(height: 20),
                  _field('Genre (optionnel)', _genreCtrl),
                  const SizedBox(height: 20),
                  _field('URL Photo (optionnel)', _photoCtrl,
                      onChanged: (_) => setState(() {})),
                  if (_photoCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _photoCtrl.text,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool number = false,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          onChanged: onChanged,
          keyboardType: number
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF12121A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          ),
        ),
      ],
    );
  }
}
