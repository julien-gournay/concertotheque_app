import 'package:cloud_firestore/cloud_firestore.dart';

class Lieu {
  final String id;
  String nom;
  String ville;
  String pays;
  String adresse;
  String type;
  int capacite;
  String photo;
  String siteWeb;

  Lieu({
    required this.id,
    required this.nom,
    required this.ville,
    this.pays = 'France',
    this.adresse = '',
    this.type = '',
    this.capacite = 0,
    this.photo = '',
    this.siteWeb = '',
  });

  factory Lieu.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Lieu(
      id:        doc.id,
      nom:       d['nom']      as String? ?? '',
      ville:     d['ville']    as String? ?? '',
      pays:      d['pays']     as String? ?? 'France',
      adresse:   d['adresse']  as String? ?? '',
      type:      d['type']     as String? ?? '',
      capacite:  (d['capacite'] as num?)?.toInt() ?? 0,
      photo:     d['photo']    as String? ?? '',
      siteWeb:   d['siteWeb']  as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'nom':      nom,
    'ville':    ville,
    'pays':     pays,
    'adresse':  adresse,
    'type':     type,
    'capacite': capacite,
    'photo':    photo,
    'siteWeb':  siteWeb,
  };

  String get displayName => ville.isNotEmpty ? '$nom, $ville' : nom;
}
