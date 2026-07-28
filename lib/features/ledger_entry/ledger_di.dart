import 'package:get_it/get_it.dart';
import '../../core/services/firebase/firestore_service.dart';
import '../../core/services/network/network_service.dart';
import 'data/datasources/ledger_remote_datasource.dart';
import 'data/repositories/ledger_repository_impl.dart';
import 'domain/repositories/ledger_repository.dart';
import 'domain/usecases/add_entry_usecase.dart';
import 'domain/usecases/delete_entry_usecase.dart';
import 'domain/usecases/settle_entry_usecase.dart';
import 'domain/usecases/watch_entries_usecase.dart';
import 'presentation/providers/ledger_provider.dart';

// ledger dependency injection
Future<void> initLedgerDependencies(GetIt sl) async {
  sl.registerLazySingleton<LedgerRemoteDataSource>(
        () => LedgerRemoteDataSource(firestoreService: sl<FirestoreService>()),
  );

  sl.registerLazySingleton<LedgerRepository>(
        () => LedgerRepositoryImpl(
      remoteDataSource: sl<LedgerRemoteDataSource>(),
      networkService: sl<NetworkService>(),
    ),
  );

  sl.registerLazySingleton<WatchEntriesUseCase>(
        () => WatchEntriesUseCase(sl<LedgerRepository>()),
  );
  sl.registerLazySingleton<AddEntryUseCase>(
        () => AddEntryUseCase(sl<LedgerRepository>()),
  );
  sl.registerLazySingleton<SettleEntryUseCase>(
        () => SettleEntryUseCase(sl<LedgerRepository>()),
  );
  sl.registerLazySingleton<DeleteEntryUseCase>(
        () => DeleteEntryUseCase(sl<LedgerRepository>()),
  );
// baki saare singleton magar ye factory kiuke is provider ko har dafa naya instance chahie hoga
  sl.registerFactory<LedgerProvider>(
        () => LedgerProvider(
      watchEntriesUseCase: sl<WatchEntriesUseCase>(),
      addEntryUseCase: sl<AddEntryUseCase>(),
      settleEntryUseCase: sl<SettleEntryUseCase>(),
      deleteEntryUseCase: sl<DeleteEntryUseCase>(),
    ),
  );
}