import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../models/lieu.dart';
import '../services/artiste_service.dart';
import '../services/evenement_service.dart';
import '../services/lieu_service.dart';
import '../widgets/artiste_picker_dialog.dart';

class EvenementEditScreen extends StatefulWidget {
  final Evenement? evenement;
  const EvenementEditScreen({super.key, this.evenement});

  @override
  State<EvenementEditScreen> createState() => _EvenementEditScreenState();
}

class _EvenementEditScreenState extends State<EvenementEditScreen> {
  final _service        = EvenementService();
  final _artisteService = ArtisteService();

  late final TextEditingController _nomCtrl;
  late final TextEditingController _villeCtrl;
  late final TextEditingController _lieuNomCtrl;
  late final TextEditingController _paysCtrl;
  late final TextEditingController _prixCtrl;
  late final TextEditingController _depCtrl;
  late final TextEditingController _afficheCtrl;
  late final TextEditingController _coverCtrl;

  late DateTime    _date;
  late String      _typeCode;
  late String      _placement;
  late List<String> _artistes;
  bool             _saving = false;

  List<Lieu> _lieux        = [];
  Lieu?      _selectedLieu;

  bool get _isEdit => widget.evenement != null;

  String _formatDate(DateTime d) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  @override
  void initState() {
    super.initState();
    final e = widget.evenement;
    _nomCtrl     = TextEditingController(text: e?.nomEvent ?? '');
    _villeCtrl   = TextEditingController(text: e?.ville    ?? '');
    _lieuNomCtrl = TextEditingController(text: e?.lieuNom  ?? '');
    _paysCtrl    = TextEditingController(text: e?.pays     ?? 'France');
    _prixCtrl    = TextEditingController(
        text: (e != null && e.prixBillet > 0)
            ? e.prixBillet.toStringAsFixed(2) : '');
    _depCtrl     = TextEditingController(
        text: (e != null && e.depenseSup > 0)
            ? e.depenseSup.toStringAsFixed(2) : '');
    _afficheCtrl = TextEditingController(text: e?.affiche ?? '');
    _coverCtrl   = TextEditingController(text: e?.cover   ?? '');
    _afficheCtrl.addListener(() => setState(() {}));
    _coverCtrl.addListener(() => setState(() {}));
    _date        = e?.date      ?? DateTime.now().add(const Duration(days: 30));
    _typeCode    = e?.typeCode  ?? 'CON';
    _placement   = e?.placement ?? 'FOSS';
    _artistes    = List<String>.from(e?.artistes ?? []);
    _loadLieux();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _villeCtrl.dispose();
    _lieuNomCtrl.dispose();
    _paysCtrl.dispose();
    _prixCtrl.dispose();
    _depCtrl.dispose();
    _afficheCtrl.dispose();
    _coverCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLieux() async {
    final lieux = await LieuService().fetchAll();
    if (!mounted) return;
    setState(() {
      _lieux = lieux;
      // Pré-sélectionne le lieu correspondant si le champ est déjà rempli
      if (_lieuNomCtrl.text.isNotEmpty && _selectedLieu == null) {
        try {
          _selectedLieu = lieux.firstWhere(
            (l) => l.nom == _lieuNomCtrl.text && l.ville == _villeCtrl.text,
          );
        } catch (_) {}
      }
    });
  }

  Future<void> _showLieuPicker() async {
    final result = await showDialog<Lieu>(
      context: context,
      builder: (ctx) {
        var searchText = '';
        var filtered = _lieux;
        return StatefulBuilder(
          builder: (ctx, setS) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Sélectionner un lieu',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: 500,
              height: 400,
              child: Column(children: [
                TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Rechercher…',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 18),
                    filled: true,
                    fillColor: const Color(0xFF12121A),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (v) => setS(() {
                    searchText = v.toLowerCase().trim();
                    filtered = searchText.isEmpty
                        ? _lieux
                        : _lieux.where((l) =>
                            l.nom.toLowerCase().contains(searchText) ||
                            l.ville.toLowerCase().contains(searchText)).toList();
                  }),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('Aucun résultat.',
                          style: TextStyle(color: Colors.white38)))
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final l = filtered[i];
                            final isSelected = _selectedLieu?.id == l.id;
                            return ListTile(
                              leading: Icon(Icons.place_outlined,
                                  color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFEF5350),
                                  size: 18),
                              title: Text(l.nom,
                                  style: TextStyle(
                                      color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                              subtitle: Text('${l.ville}, ${l.pays}',
                                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              onTap: () => Navigator.pop(ctx, l),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            );
                          }),
                ),
              ]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Annuler', style: TextStyle(color: Colors.white60)),
              ),
            ],
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _selectedLieu     = result;
        _lieuNomCtrl.text = result.nom;
        _villeCtrl.text   = result.ville;
        _paysCtrl.text    = result.pays;
      });
    }
  }

  Future<void> _showCreateLieu() async {
    final nomCtrl   = TextEditingController();
    final villeCtrl = TextEditingController();
    final paysCtrl  = TextEditingController(text: 'France');

    Widget dialogField(String label, TextEditingController ctrl) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0D0D14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          ),
        ),
      ],
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nouveau lieu',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 400,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            dialogField('Nom *', nomCtrl),
            const SizedBox(height: 12),
            dialogField('Ville *', villeCtrl),
            const SizedBox(height: 12),
            dialogField('Pays', paysCtrl),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (nomCtrl.text.trim().isEmpty || villeCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, true);
            },
            child: const Text('Créer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = LieuService();
      final nouveau = Lieu(
        id: '', nom: nomCtrl.text.trim(),
        ville: villeCtrl.text.trim(), pays: paysCtrl.text.trim(),
      );
      await service.add(nouveau);
      final lieux = await service.fetchAll();
      if (mounted) {
        Lieu? created;
        try {
          created = lieux.firstWhere(
              (l) => l.nom == nouveau.nom && l.ville == nouveau.ville);
        } catch (_) {}
        setState(() {
          _lieux        = lieux;
          _selectedLieu = created;
          if (created != null) {
            _lieuNomCtrl.text = created.nom;
            _villeCtrl.text   = created.ville;
            _paysCtrl.text    = created.pays;
          }
        });
      }
    }
    nomCtrl.dispose();
    villeCtrl.dispose();
    paysCtrl.dispose();
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
        widget.evenement!
          ..nomEvent   = nom
          ..date       = _date
          ..typeCode   = _typeCode
          ..placement  = _placement
          ..prixBillet = double.tryParse(_prixCtrl.text)  ?? 0
          ..depenseSup = double.tryParse(_depCtrl.text)   ?? 0
          ..affiche    = _afficheCtrl.text.trim()
          ..cover      = _coverCtrl.text.trim()
          ..lieuNom    = _lieuNomCtrl.text.trim()
          ..ville      = ville
          ..pays       = _paysCtrl.text.trim()
          ..artistes   = List<String>.from(_artistes);
        await _service.update(widget.evenement!);
      } else {
        await _service.add(Evenement(
          id:         '',
          nomEvent:   nom,
          date:       _date,
          typeCode:   _typeCode,
          placement:  _placement,
          prixBillet: double.tryParse(_prixCtrl.text)  ?? 0,
          depenseSup: double.tryParse(_depCtrl.text)   ?? 0,
          affiche:    _afficheCtrl.text.trim(),
          cover:      _coverCtrl.text.trim(),
          lieuNom:    _lieuNomCtrl.text.trim(),
          ville:      ville,
          pays:       _paysCtrl.text.trim(),
          artistes:   List<String>.from(_artistes),
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
            // ── Header ──────────────────────────────────────────────────────
            Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                tooltip: 'Retour',
              ),
              const SizedBox(width: 8),
              Text(
                _isEdit ? "Modifier l'événement" : 'Nouvel événement',
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
            const SizedBox(height: 32),
            // ── Formulaire ───────────────────────────────────────────────────
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
                  _field("Nom de l'événement *", _nomCtrl),
                  const SizedBox(height: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: _datePicker()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _dropdown<String>(
                        label: 'Type',
                        value: _typeCode,
                        items: const [
                          ('CON', 'Concert'),
                          ('FES', 'Festival'),
                          ('SOI', 'Soirée'),
                          ('SHO', 'Showcase'),
                          ('COM', 'Comédie musicale'),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _typeCode = v);
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(height: 32),
                  _section('Lieu'),
                  const SizedBox(height: 16),
                  // ── Sélecteur de lieu ──────────────────────────────────
                  Row(children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _lieux.isEmpty ? null : _showLieuPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 13),
                          decoration: BoxDecoration(
                            color: const Color(0xFF12121A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            const Icon(Icons.place_outlined,
                                color: Colors.white38, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedLieu != null
                                    ? _selectedLieu!.displayName
                                    : (_lieux.isEmpty
                                        ? 'Chargement des lieux…'
                                        : 'Choisir un lieu existant…'),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _selectedLieu != null
                                      ? Colors.white
                                      : Colors.white38,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Icon(Icons.expand_more,
                                color: Colors.white38, size: 16),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Créer un nouveau lieu',
                      child: IconButton(
                        onPressed: _showCreateLieu,
                        icon: const Icon(Icons.add_circle_outline,
                            color: Color(0xFFFF6B35)),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 2,
                        child: _field('Nom du lieu', _lieuNomCtrl)),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 2, child: _field('Ville *', _villeCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _field('Pays', _paysCtrl)),
                  ]),
                  const SizedBox(height: 32),
                  _section('Billet'),
                  const SizedBox(height: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: _dropdown<String>(
                        label: 'Placement',
                        value: _placement,
                        items: const [
                          ('FOSS', 'Fosse'),
                          ('GRAD', 'Gradin'),
                          ('CAT1', 'Catégorie 1'),
                          ('CAT2', 'Catégorie 2'),
                          ('CAT3', 'Catégorie 3'),
                          ('CAT4', 'Catégorie 4'),
                          ('CARO', 'Carré Or'),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _placement = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child:
                            _field('Prix billet (€)', _prixCtrl, number: true)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _field('Dépense sup. (€)', _depCtrl,
                            number: true)),
                  ]),
                  const SizedBox(height: 32),
                  _section('Artistes'),
                  const SizedBox(height: 16),
                  _artistePicker(),
                  const SizedBox(height: 32),
                  _section('Médias (optionnel)'),
                  const SizedBox(height: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: _field('URL Affiche', _afficheCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _field('URL Cover', _coverCtrl)),
                  ]),
                  if (_afficheCtrl.text.isNotEmpty || _coverCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(children: [
                      if (_afficheCtrl.text.isNotEmpty)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Affiche',
                                  style: TextStyle(color: Colors.white38, fontSize: 11)),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _afficheCtrl.text,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    child: const Text('URL invalide',
                                        style: TextStyle(color: Colors.white38, fontSize: 12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_afficheCtrl.text.isNotEmpty && _coverCtrl.text.isNotEmpty)
                        const SizedBox(width: 16),
                      if (_coverCtrl.text.isNotEmpty)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cover',
                                  style: TextStyle(color: Colors.white38, fontSize: 11)),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _coverCtrl.text,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    child: const Text('URL invalide',
                                        style: TextStyle(color: Colors.white38, fontSize: 12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Widgets helper ────────────────────────────────────────────────────────

  Widget _section(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
          color: Color(0xFFFF6B35),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    ),
  );

  Widget _field(String label, TextEditingController ctrl,
      {bool number = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
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

  Widget _datePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date',
            style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2035),
              builder: (ctx, child) => Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFFFF6B35),
                    surface: Color(0xFF1E1E2C),
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) setState(() => _date = picked);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFF12121A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              const Icon(Icons.calendar_today_outlined,
                  color: Colors.white54, size: 16),
              const SizedBox(width: 8),
              Text(_formatDate(_date),
                  style:
                      const TextStyle(color: Colors.white, fontSize: 14)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<(T, String)> items,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              dropdownColor: const Color(0xFF1E1E2C),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: onChanged,
              items: items
                  .map((item) => DropdownMenuItem<T>(
                        value: item.$1,
                        child: Text(item.$2,
                            style: const TextStyle(color: Colors.white)),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _artistePicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_artistes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _artistes
                    .map((nom) => Chip(
                          label: Text(nom,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                          backgroundColor: const Color(0xFF2A2A3C),
                          side: BorderSide.none,
                          deleteIconColor: Colors.white54,
                          onDeleted: () =>
                              setState(() => _artistes.remove(nom)),
                        ))
                    .toList(),
              ),
            ),
          TextButton.icon(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () async {
              final result = await showArtistePicker(
                context: context,
                initialSelected: _artistes,
                stream: _artisteService.stream(),
              );
              if (result != null) setState(() => _artistes = result);
            },
            icon: const Icon(Icons.add, size: 16, color: Color(0xFFFF6B35)),
            label: const Text('Sélectionner des artistes',
                style: TextStyle(color: Color(0xFFFF6B35), fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
