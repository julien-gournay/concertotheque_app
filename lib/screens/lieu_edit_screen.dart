import 'package:flutter/material.dart';
import '../models/lieu.dart';
import '../services/lieu_service.dart';

const _typeOptions = [
  '',
  'Salle de concert',
  'Arena',
  'Stade',
  'Parc',
  "Parc d'expo",
  'Boite de nuit',
  'Château',
  'Monument',
  'Autre',
];

class LieuEditScreen extends StatefulWidget {
  final Lieu? lieu;
  const LieuEditScreen({super.key, this.lieu});

  @override
  State<LieuEditScreen> createState() => _LieuEditScreenState();
}

class _LieuEditScreenState extends State<LieuEditScreen> {
  final _service = LieuService();

  late final TextEditingController _nomCtrl;
  late final TextEditingController _villeCtrl;
  late final TextEditingController _paysCtrl;
  late final TextEditingController _adresseCtrl;
  late final TextEditingController _capaciteCtrl;
  late final TextEditingController _photoCtrl;
  late final TextEditingController _siteWebCtrl;
  late String _type;
  bool _saving = false;

  bool get _isEdit => widget.lieu != null;

  @override
  void initState() {
    super.initState();
    final l = widget.lieu;
    _nomCtrl      = TextEditingController(text: l?.nom     ?? '');
    _villeCtrl    = TextEditingController(text: l?.ville   ?? '');
    _paysCtrl     = TextEditingController(text: l?.pays    ?? 'France');
    _adresseCtrl  = TextEditingController(text: l?.adresse ?? '');
    _capaciteCtrl = TextEditingController(
        text: (l != null && l.capacite > 0) ? '${l.capacite}' : '');
    _photoCtrl    = TextEditingController(text: l?.photo   ?? '');
    _siteWebCtrl  = TextEditingController(text: l?.siteWeb ?? '');
    // Map type to dropdown option, fallback to '' if not in list
    final existing = l?.type ?? '';
    _type = _typeOptions.contains(existing) ? existing : '';
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _villeCtrl.dispose();
    _paysCtrl.dispose();
    _adresseCtrl.dispose();
    _capaciteCtrl.dispose();
    _photoCtrl.dispose();
    _siteWebCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nom   = _nomCtrl.text.trim();
    final ville = _villeCtrl.text.trim();
    if (nom.isEmpty || ville.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Le nom et la ville sont obligatoires.'),
        backgroundColor: Color(0xFFD32F2F),
      ));
      return;
    }
    setState(() => _saving = true);
    try {
      if (_isEdit) {
        widget.lieu!
          ..nom      = nom
          ..ville    = ville
          ..pays     = _paysCtrl.text.trim()
          ..adresse  = _adresseCtrl.text.trim()
          ..type     = _type
          ..capacite = int.tryParse(_capaciteCtrl.text) ?? 0
          ..photo    = _photoCtrl.text.trim()
          ..siteWeb  = _siteWebCtrl.text.trim();
        await _service.update(widget.lieu!);
      } else {
        await _service.add(Lieu(
          id:       '',
          nom:      nom,
          ville:    ville,
          pays:     _paysCtrl.text.trim(),
          adresse:  _adresseCtrl.text.trim(),
          type:     _type,
          capacite: int.tryParse(_capaciteCtrl.text) ?? 0,
          photo:    _photoCtrl.text.trim(),
          siteWeb:  _siteWebCtrl.text.trim(),
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
            // ── Header ────────────────────────────────────────────────────
            Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                tooltip: 'Retour',
              ),
              const SizedBox(width: 8),
              Text(
                _isEdit ? 'Modifier le lieu' : 'Nouveau lieu',
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
                    width: 20, height: 20,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
            const SizedBox(height: 32),
            // ── Formulaire ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section('Informations générales'),
                  const SizedBox(height: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 2, child: _field('Nom *', _nomCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _typeDropdown()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _field('Capacité', _capaciteCtrl, number: true),
                    ),
                  ]),
                  const SizedBox(height: 32),
                  _section('Localisation'),
                  const SizedBox(height: 16),
                  _field('Adresse', _adresseCtrl),
                  const SizedBox(height: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 2, child: _field('Ville *', _villeCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _field('Pays', _paysCtrl)),
                  ]),
                  const SizedBox(height: 32),
                  _section('Médias & liens'),
                  const SizedBox(height: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: _field('URL Photo', _photoCtrl,
                        onChanged: (_) => setState(() {}))),
                    const SizedBox(width: 16),
                    Expanded(child: _field('Site web', _siteWebCtrl)),
                  ]),
                  if (_photoCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _photoCtrl.text,
                        height: 140,
                        width: 140,
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

  Widget _typeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Type',
            style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _type,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E1E2C),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (v) { if (v != null) setState(() => _type = v); },
              items: _typeOptions.map((t) => DropdownMenuItem(
                value: t,
                child: Text(
                  t.isEmpty ? '— Aucun —' : t,
                  style: TextStyle(
                    color: t.isEmpty ? Colors.white38 : Colors.white,
                    fontSize: 14,
                  ),
                ),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _section(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
          color: Color(0xFFEF5350),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    ),
  );

  Widget _field(String label, TextEditingController ctrl,
      {bool number = false, String? hint, void Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          onChanged: onChanged,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
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
