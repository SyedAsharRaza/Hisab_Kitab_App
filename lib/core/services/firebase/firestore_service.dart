import 'package:cloud_firestore/cloud_firestore.dart';
import '../logger/logger_service.dart';

//wrapper around FirebaseFirestore
class FirestoreService {
  final FirebaseFirestore _firestore;
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }
  Future<DocumentReference<Map<String, dynamic>>> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      AppLogger.error('Failed to add document in $collectionPath', 'Firestore', e);
      rethrow;
    }
  }

  Future<void> setDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).set(data);
    } catch (e) {
      AppLogger.error('Failed to set document $docId in $collectionPath', 'Firestore', e);
      rethrow;
    }
  }

  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      AppLogger.error('Failed to update document $docId in $collectionPath', 'Firestore', e);
      rethrow;
    }
  }

  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      AppLogger.error('Failed to delete document $docId in $collectionPath', 'Firestore', e);
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }
}