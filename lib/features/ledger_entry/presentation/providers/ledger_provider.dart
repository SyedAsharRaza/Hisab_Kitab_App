import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../domain/entities/ledger_entry_entity.dart';
import '../../domain/usecases/add_entry_usecase.dart';
import '../../domain/usecases/delete_entry_usecase.dart';
import '../../domain/usecases/settle_entry_usecase.dart';
import '../../domain/usecases/watch_entries_usecase.dart';

// dashboard me use horha hay
class LedgerProvider extends ChangeNotifier {
  final WatchEntriesUseCase _watchEntriesUseCase;
  final AddEntryUseCase _addEntryUseCase;
  final SettleEntryUseCase _settleEntryUseCase;
  final DeleteEntryUseCase _deleteEntryUseCase;

  LedgerProvider({
    required WatchEntriesUseCase watchEntriesUseCase,
    required AddEntryUseCase addEntryUseCase,
    required SettleEntryUseCase settleEntryUseCase,
    required DeleteEntryUseCase deleteEntryUseCase,
  })  : _watchEntriesUseCase = watchEntriesUseCase,
        _addEntryUseCase = addEntryUseCase,
        _settleEntryUseCase = settleEntryUseCase,
        _deleteEntryUseCase = deleteEntryUseCase;

  StreamSubscription? _subscription;
  ViewStatus _status = ViewStatus.initial;
  ViewStatus get status => _status;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<LedgerEntryEntity> _entries = [];
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  // ek dafa user ka pata chal jae, then isko call kardunga
  void startWatching(String userId) {
    _status = ViewStatus.loading;
    notifyListeners();
    _subscription?.cancel();
    _subscription = _watchEntriesUseCase(userId: userId).listen(
          (result) {
        result.fold(
              (failure) {
            _status = ViewStatus.error;
            _errorMessage = failure.message;
            notifyListeners();
          },
              (entries) {
            _entries = entries;
            _status = ViewStatus.success;
            _errorMessage = null;
            notifyListeners();
          },
        );
      },
      onError: (e) {
        AppLogger.error('Ledger stream error', 'LedgerProvider', e);
        _status = ViewStatus.error;
        _errorMessage = 'Something went wrong loading your ledger.';
        notifyListeners();
      },
    );
  }

  List<LedgerEntryEntity> get pendingEntries =>
      _entries.where((e) => e.isPending).toList();
  List<LedgerEntryEntity> get owedToMeEntries => pendingEntries
      .where((e) => e.direction == LedgerDirection.theyOweMe)
      .toList();
  List<LedgerEntryEntity> get iOweEntries => pendingEntries
      .where((e) => e.direction == LedgerDirection.iOweThem)
      .toList();
  double get totalReceivable =>
      owedToMeEntries.fold(0.0, (sum, e) => sum + e.amount);
  double get totalPayable =>
      iOweEntries.fold(0.0, (sum, e) => sum + e.amount);
  double get netBalance => totalReceivable - totalPayable;
  bool get isNetPositive => netBalance >= 0;
  Future<bool> addEntry(LedgerEntryEntity entry) async {
    _isSubmitting = true;
    notifyListeners();
    final result = await _addEntryUseCase(entry);
    _isSubmitting = false;
    notifyListeners();
    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
          (_) => true,
    );
  }

  Future<bool> settleEntry(String entryId) async {
    final result = await _settleEntryUseCase(entryId: entryId);
    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
          (_) => true,
    );
  }

  Future<bool> deleteEntry(String entryId) async {
    final result = await _deleteEntryUseCase(entryId: entryId);
    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
          (_) => true,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}