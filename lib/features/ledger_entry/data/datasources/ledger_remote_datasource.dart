import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../models/ledger_entry_model.dart';

class LedgerRemoteDataSource {
  final FirestoreService _firestoreService;
  LedgerRemoteDataSource({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  Stream<List<LedgerEntryModel>> watchEntries({required String userId}) {
    return _firestoreService
        .streamCollection(
      collectionPath: AppConstants.ledgerEntriesCollection,
      queryBuilder: (query) => query
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true),
    )
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LedgerEntryModel.fromMap(doc.id, doc.data()))
          .toList();
    }).handleError((e) {
      AppLogger.error('watchEntries stream error', 'LedgerRemote', e);
      throw e;
    });
  }
  Future<void> addEntry(LedgerEntryModel entry) async {
    await _firestoreService.addDocument(
      collectionPath: AppConstants.ledgerEntriesCollection,
      data: entry.toMap(),
    );
  }

  Future<void> settleEntry({required String entryId}) async {
    await _firestoreService.updateDocument(
      collectionPath: AppConstants.ledgerEntriesCollection,
      docId: entryId,
      data: {
        'status': 1, // 1 ka matlab settled, 0 ka matlab unsettled
        'settledAt': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  Future<void> deleteEntry({required String entryId}) async {
    await _firestoreService.deleteDocument(
      collectionPath: AppConstants.ledgerEntriesCollection,
      docId: entryId,
    );
  }
}