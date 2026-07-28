import '../../../../core/utils/result.dart';
import '../repositories/ledger_repository.dart';

class SettleEntryUseCase {
  final LedgerRepository repository;
  const SettleEntryUseCase(this.repository);

  Future<Result<void>> call({required String entryId}) {
    return repository.settleEntry(entryId: entryId);
  }
}