import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/concert.dart';

class EvenementService {
  final _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _col {
    final uid = _uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('evenements');
  }

  static const pageSize = 25;

  Future<({
    List<Evenement> items,
    bool hasMore,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
  })> fetchPage({
    QueryDocumentSnapshot<Map<String, dynamic>>? cursor,
  }) async {
    final col = _col;
    if (col == null) return (items: <Evenement>[], hasMore: false, lastDoc: null);

    var q = col.orderBy('date').limit(pageSize + 1);
    if (cursor != null) q = q.startAfterDocument(cursor);

    final snap = await q.get();
    final hasMore = snap.docs.length > pageSize;
    final docs = snap.docs.take(pageSize).toList();
    return (
      items: docs.map(Evenement.fromDoc).toList(),
      hasMore: hasMore,
      lastDoc: docs.isNotEmpty ? docs.last : null,
    );
  }

  Future<List<Evenement>> fetchAll() async {
    final col = _col;
    if (col == null) return [];
    final snap = await col.orderBy('date').get();
    return snap.docs.map(Evenement.fromDoc).toList();
  }

  Future<void> add(Evenement e) async => _col?.add(e.toMap());

  Future<void> update(Evenement e) async => _col?.doc(e.id).update(e.toMap());

  Future<void> delete(String id) async => _col?.doc(id).delete();
}
