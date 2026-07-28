import '../../../../core/utils/result.dart';
import '../entities/ledger_entry_entity.dart';
import '../repositories/ledger_repository.dart';

class WatchEntriesUseCase {
  final LedgerRepository repository;
  const WatchEntriesUseCase(this.repository);

  Stream<Result<List<LedgerEntryEntity>>> call({required String userId}) {
    return repository.watchEntries(userId: userId);
  }
}