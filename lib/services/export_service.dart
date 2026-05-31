import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../models/artiste.dart';
import '../models/concert.dart';
import '../models/lieu.dart';

class ExportService {
  /// Ouvre le dialogue natif "Enregistrer sous" et écrit un CSV UTF-8 (avec BOM pour Excel).
  /// Retourne le chemin du fichier créé, ou null si l'utilisateur annule.
  static Future<String?> exportConcertsCsv(List<Evenement> concerts) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Enregistrer l\'export CSV',
      fileName: 'concerts_$today.csv',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (path == null) return null;

    final buf = StringBuffer();
    // BOM UTF-8 — Excel l'utilise pour détecter l'encodage
    buf.write('﻿');
    buf.writeln('Nom,Date,Type,Lieu,Ville,Pays,Placement,Prix billet (€),Dépense sup. (€),Artistes,Statut');

    for (final e in concerts) {
      buf.writeln([
        _q(e.nomEvent),
        e.date.toIso8601String().substring(0, 10),
        _q(e.type.label),
        _q(e.lieuNom),
        _q(e.ville),
        _q(e.pays),
        _q(e.placement),
        e.prixBillet.toStringAsFixed(2),
        e.depenseSup.toStringAsFixed(2),
        _q(e.artistes.join('; ')),
        e.isArchive ? 'Archivé' : 'En cours',
      ].join(','));
    }

    await File(path).writeAsString(buf.toString());
    return path;
  }

  static Future<String?> exportArtistesCsv(List<Artiste> artistes) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Enregistrer l\'export CSV',
      fileName: 'artistes_$today.csv',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (path == null) return null;

    final buf = StringBuffer();
    buf.write('﻿');
    buf.writeln('Nom,Genre,Photo');
    for (final a in artistes) {
      buf.writeln([_q(a.nom), _q(a.genre), _q(a.photo)].join(','));
    }

    await File(path).writeAsString(buf.toString());
    return path;
  }

  static Future<String?> exportLieuxCsv(List<Lieu> lieux) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Enregistrer l\'export CSV',
      fileName: 'lieux_$today.csv',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (path == null) return null;

    final buf = StringBuffer();
    buf.write('﻿');
    buf.writeln('Nom,Ville,Pays,Adresse,Type,Capacité,Photo,Site web');
    for (final l in lieux) {
      buf.writeln([
        _q(l.nom),
        _q(l.ville),
        _q(l.pays),
        _q(l.adresse),
        _q(l.type),
        l.capacite > 0 ? '${l.capacite}' : '',
        _q(l.photo),
        _q(l.siteWeb),
      ].join(','));
    }

    await File(path).writeAsString(buf.toString());
    return path;
  }

  static String _q(String v) {
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }
}
