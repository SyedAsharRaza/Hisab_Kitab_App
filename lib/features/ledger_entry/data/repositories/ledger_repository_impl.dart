import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/services/network/network_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/ledger_entry_entity.dart';
import '../../domain/repositories/ledger_repository.dart';
import '../datasources/ledger_remote_datasource.dart';
import '../models/ledger_entry_model.dart';

// isko bhi LedgerRepository contract ko fulfill karna parega
class LedgerRepositoryImpl implements LedgerRepository {
  final LedgerRemoteDataSource _remoteDataSource;
  final NetworkService _networkService;
  LedgerRepositoryImpl({
    required LedgerRemoteDataSource remoteDataSource,
    required NetworkService networkService,
  })  : _remoteDataSource = remoteDataSource,
        _networkService = networkService;

  @override
  Stream<Result<List<LedgerEntryEntity>>> watchEntries({required String userId}) {
    return _remoteDataSource.watchEntries(userId: userId).transform(
      StreamTransformer<List<LedgerEntryModel>, Result<List<LedgerEntryEntity>>>.fromHandlers(
        handleData: (entries, sink) {
          sink.add(Result.success(entries));
        },
        handleError: (error, stackTrace, sink) {
          AppLogger.error('watchEntries failed', 'LedgerRepository', error);
          sink.add(Result.failure(const ServerFailure('Failed to load your ledger.')));
        },
      ),
    );
  }

  @override
  Future<Result<void>> addEntry(LedgerEntryEntity entry) async {
    if (!await _networkService.isConnected) {
      return Result.failure(const NetworkFailure());
    }
    try {
      await _remoteDataSource.addEntry(LedgerEntryModel.fromEntity(entry));
      return Result.success(null);
    } catch (e) {
      AppLogger.error('addEntry failed', 'LedgerRepository', e);
      return Result.failure(const ServerFailure('Failed to save entry. Please try again.'));
    }
  }

  @override
  Future<Result<void>> settleEntry({required String entryId}) async {
    if (!await _networkService.isConnected) {
      return Result.failure(const NetworkFailure());
    }
    try {
      await _remoteDataSource.settleEntry(entryId: entryId);
      return Result.success(null);
    } catch (e) {
      AppLogger.error('settleEntry failed', 'LedgerRepository', e);
      return Result.failure(const ServerFailure('Failed to settle entry. Please try again.'));
    }
  }

  @override
  Future<Result<void>> deleteEntry({required String entryId}) async {
    if (!await _networkService.isConnected) {
      return Result.failure(const NetworkFailure());
    }
    try {
      await _remoteDataSource.deleteEntry(entryId: entryId);
      return Result.success(null);
    } catch (e) {
      AppLogger.error('deleteEntry failed', 'LedgerRepository', e);
      return Result.failure(const ServerFailure('Failed to delete entry. Please try again.'));
    }
  }
}