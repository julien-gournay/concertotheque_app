import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lieu.dart';

class LieuService {
  final _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _col {
    final uid = _uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('lieux');
  }

  Stream<List<Lieu>> stream() {
    final col = _col;
    if (col == null) return Stream.value([]);
    return col.orderBy('nom').snapshots().map(
      (snap) => snap.docs.map(Lieu.fromDoc).toList(),
    );
  }

  Future<List<Lieu>> fetchAll() async {
    final col = _col;
    if (col == null) return [];
    final snap = await col.orderBy('nom').get();
    return snap.docs.map(Lieu.fromDoc).toList();
  }

  static const pageSize = 25;

  Future<({
    List<Lieu> items,
    bool hasMore,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
  })> fetchPage({
    QueryDocumentSnapshot<Map<String, dynamic>>? cursor,
  }) async {
    final col = _col;
    if (col == null) return (items: <Lieu>[], hasMore: false, lastDoc: null);

    var q = col.orderBy('nom').limit(pageSize + 1);
    if (cursor != null) q = q.startAfterDocument(cursor);

    final snap = await q.get();
    final hasMore = snap.docs.length > pageSize;
    final docs = snap.docs.take(pageSize).toList();
    return (
      items: docs.map(Lieu.fromDoc).toList(),
      hasMore: hasMore,
      lastDoc: docs.isNotEmpty ? docs.last : null,
    );
  }

  Future<void> add(Lieu l) async => _col?.add(l.toMap());

  Future<void> update(Lieu l) async => _col?.doc(l.id).update(l.toMap());

  Future<void> delete(String id) async => _col?.doc(id).delete();
}
