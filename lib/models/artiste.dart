import 'package:cloud_firestore/cloud_firestore.dart';

class Artiste {
  final String id;
  String nom;
  String genre;
  String photo;

  Artiste({
    required this.id,
    required this.nom,
    this.genre = '',
    this.photo = '',
  });

  factory Artiste.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Artiste(
      id:     doc.id,
      nom:    d['nom']   as String? ?? '',
      genre:  d['genre'] as String? ?? '',
      photo:  d['photo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'nom':   nom,
    'genre': genre,
    'photo': photo,
  };
}
