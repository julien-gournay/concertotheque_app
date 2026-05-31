import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/artiste.dart';

class ArtisteService {
  final _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _col {
    final uid = _uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('artistes');
  }

  Stream<List<Artiste>> stream() {
    final col = _col;
    if (col == null) return Stream.value([]);
    return col.orderBy('nom').snapshots().map(
      (snap) => snap.docs.map(Artiste.fromDoc).toList(),
    );
  }

  static const pageSize = 25;

  Future<({
    List<Artiste> items,
    bool hasMore,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
  })> fetchPage({
    QueryDocumentSnapshot<Map<String, dynamic>>? cursor,
  }) async {
    final col = _col;
    if (col == null) return (items: <Artiste>[], hasMore: false, lastDoc: null);

    var q = col.orderBy('nom').limit(pageSize + 1);
    if (cursor != null) q = q.startAfterDocument(cursor);

    final snap = await q.get();
    final hasMore = snap.docs.length > pageSize;
    final docs = snap.docs.take(pageSize).toList();
    return (
      items: docs.map(Artiste.fromDoc).toList(),
      hasMore: hasMore,
      lastDoc: docs.isNotEmpty ? docs.last : null,
    );
  }

  Future<List<Artiste>> fetchAll() async {
    final col = _col;
    if (col == null) return [];
    final snap = await col.orderBy('nom').get();
    return snap.docs.map(Artiste.fromDoc).toList();
  }

  Future<void> add(Artiste a) async => _col?.add(a.toMap());

  Future<void> update(Artiste a) async => _col?.doc(a.id).update(a.toMap());

  Future<void> delete(String id) async => _col?.doc(id).delete();
}
