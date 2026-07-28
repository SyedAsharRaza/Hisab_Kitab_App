import 'package:get_it/get_it.dart';
import '../../core/services/firebase/firebase_auth_service.dart';
import '../../core/services/firebase/firestore_service.dart';
import '../../core/services/network/network_service.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_current_user_usecase.dart';
import 'domain/usecases/sign_in_usecase.dart';
import 'domain/usecases/sign_out_usecase.dart';
import 'domain/usecases/sign_up_usecase.dart';
import 'presentation/providers/auth_provider.dart';

// feature level dependency injection
// one time call from injection_container.dart
Future<void> initAuthDependencies(GetIt sl) async {
  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(
      authService: sl<FirebaseAuthService>(),
      firestoreService: sl<FirestoreService>(),
    ),
  );
  // repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkService: sl<NetworkService>(),
    ),
  );
  // use cases
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );

  // provider ko yaha par factory bana raha hu take har dafa new create ho jaye
  // wese singleton bhi use kar sakta hu
  sl.registerFactory<AuthProvider>(
        () => AuthProvider(
      signUpUseCase: sl<SignUpUseCase>(),
      signInUseCase: sl<SignInUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
    ),
  );
}