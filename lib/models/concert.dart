import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// CON=Concert, FES=Festival, SOI=Soirée, SHO=Showcase, COM=Comédie musicale
enum ConcertType { concert, festival, soiree, showcase, comedie }

extension ConcertTypeX on ConcertType {
  String get label {
    switch (this) {
      case ConcertType.concert:  return 'Concert';
      case ConcertType.festival: return 'Festival';
      case ConcertType.soiree:   return 'Soirée';
      case ConcertType.showcase: return 'Showcase';
      case ConcertType.comedie:  return 'Comédie';
    }
  }

  String get code {
    switch (this) {
      case ConcertType.concert:  return 'CON';
      case ConcertType.festival: return 'FES';
      case ConcertType.soiree:   return 'SOI';
      case ConcertType.showcase: return 'SHO';
      case ConcertType.comedie:  return 'COM';
    }
  }

  Color get color {
    switch (this) {
      case ConcertType.concert:  return const Color(0xFFE91E63);
      case ConcertType.festival: return const Color(0xFF43A047);
      case ConcertType.soiree:   return const Color(0xFF7B1FA2);
      case ConcertType.showcase: return const Color(0xFF0288D1);
      case ConcertType.comedie:  return const Color(0xFFE65100);
    }
  }
}

ConcertType concertTypeFromCode(String code) {
  switch (code) {
    case 'FES': return ConcertType.festival;
    case 'SOI': return ConcertType.soiree;
    case 'SHO': return ConcertType.showcase;
    case 'COM': return ConcertType.comedie;
    default:    return ConcertType.concert;
  }
}

// CARO=Carré Or, CAT1-4=Catégories, FOSS=Fosse, GRAD=Gradin
const placementLabels = {
  'FOSS': 'Fosse',
  'GRAD': 'Gradin',
  'CAT1': 'Catégorie 1',
  'CAT2': 'Catégorie 2',
  'CAT3': 'Catégorie 3',
  'CAT4': 'Catégorie 4',
  'CARO': 'Carré Or',
};

class Evenement {
  final String id;
  String nomEvent;
  DateTime date;
  String typeCode;
  String placement;
  double prixBillet;
  double depenseSup;
  String affiche;
  String cover;
  String lieuNom;
  String ville;
  String pays;
  List<String> artistes;

  Evenement({
    required this.id,
    required this.nomEvent,
    required this.date,
    required this.typeCode,
    this.placement = 'FOSS',
    this.prixBillet = 0,
    this.depenseSup = 0,
    this.affiche = '',
    this.cover = '',
    this.lieuNom = '',
    required this.ville,
    this.pays = 'France',
    this.artistes = const [],
  });

  ConcertType get type => concertTypeFromCode(typeCode);

  // Status calculé depuis la date — pas de champ SQL
  bool get isArchive => date.isBefore(DateTime.now());

  factory Evenement.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Evenement(
      id: doc.id,
      nomEvent:   d['nomEvent']   as String? ?? '',
      date:       (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      typeCode:   d['type']       as String? ?? 'CON',
      placement:  d['placement']  as String? ?? 'FOSS',
      prixBillet: (d['prixBillet']  as num?)?.toDouble() ?? 0,
      depenseSup: (d['depenseSup']  as num?)?.toDouble() ?? 0,
      affiche:    d['affiche']    as String? ?? '',
      cover:      d['cover']      as String? ?? '',
      lieuNom:    d['lieuNom']    as String? ?? '',
      ville:      d['ville']      as String? ?? '',
      pays:       d['pays']       as String? ?? '',
      artistes:   List<String>.from(d['artistes'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'nomEvent':   nomEvent,
    'date':       Timestamp.fromDate(date),
    'type':       typeCode,
    'placement':  placement,
    'prixBillet': prixBillet,
    'depenseSup': depenseSup,
    'affiche':    affiche,
    'cover':      cover,
    'lieuNom':    lieuNom,
    'ville':      ville,
    'pays':       pays,
    'artistes':   artistes,
  };
}
