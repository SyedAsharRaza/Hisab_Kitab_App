import '../../../../core/utils/result.dart';
import '../entities/ledger_entry_entity.dart';

abstract class LedgerRepository {
  // ledger entries ki stream, is current user ki
  Stream<Result<List<LedgerEntryEntity>>> watchEntries({required String userId});
  Future<Result<void>> addEntry(LedgerEntryEntity entry);
  Future<Result<void>> settleEntry({required String entryId});
  Future<Result<void>> deleteEntry({required String entryId});
}