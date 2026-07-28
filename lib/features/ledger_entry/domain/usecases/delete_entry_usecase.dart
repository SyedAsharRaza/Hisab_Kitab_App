import '../../../../core/utils/result.dart';
import '../repositories/ledger_repository.dart';

class DeleteEntryUseCase {
  final LedgerRepository repository;
  const DeleteEntryUseCase(this.repository);

  Future<Result<void>> call({required String entryId}) {
    return repository.deleteEntry(entryId: entryId);
  }
}