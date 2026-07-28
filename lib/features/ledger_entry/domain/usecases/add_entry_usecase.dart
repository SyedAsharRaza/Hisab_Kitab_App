import '../../../../core/utils/result.dart';
import '../entities/ledger_entry_entity.dart';
import '../repositories/ledger_repository.dart';

class AddEntryUseCase {
  final LedgerRepository repository;
  const AddEntryUseCase(this.repository);

  Future<Result<void>> call(LedgerEntryEntity entry) {
    return repository.addEntry(entry);
  }
}