import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/logger/logger_service.dart';
import '../core/services/local_storage/local_storage_service.dart';
import '../core/services/network/network_service.dart';
import '../core/services/firebase/firebase_auth_service.dart';
import '../core/services/firebase/firestore_service.dart';
import '../features/auth/auth_di.dart';
import '../features/ledger_entry/ledger_di.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  AppLogger.info('Initializing dependencies', 'DI');

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<LocalStorageService>(
        () => LocalStorageService(prefs: sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<NetworkService>(() => NetworkService());

  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  sl.registerLazySingleton<FirestoreService>(() => FirestoreService());

  await initAuthDependencies(sl);
  await initLedgerDependencies(sl);

  AppLogger.info('Dependencies initialized', 'DI');
}