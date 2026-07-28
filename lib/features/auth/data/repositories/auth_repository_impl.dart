import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../../../core/services/network/network_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkService _networkService;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required NetworkService networkService,
  })  : _remoteDataSource = remoteDataSource,
        _networkService = networkService;

  @override
  Future<Result<UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await _networkService.isConnected) {
      return Result.failure(const NetworkFailure());
    }
    try {
      final user = await _remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('SignUp failed: ${e.code}', 'AuthRepository', e);
      return Result.failure(AuthFailureMapper.fromCode(e.code));
    } catch (e) {
      AppLogger.error('SignUp unexpected error', 'AuthRepository', e);
      return Result.failure(const ServerFailure());
    }
  }

  @override
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    if (!await _networkService.isConnected) {
      return Result.failure(const NetworkFailure());
    }
    try {
      final user = await _remoteDataSource.signIn(email: email, password: password);
      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('SignIn failed: ${e.code}', 'AuthRepository', e);
      return Result.failure(AuthFailureMapper.fromCode(e.code));
    } catch (e) {
      AppLogger.error('SignIn unexpected error', 'AuthRepository', e);
      return Result.failure(const ServerFailure());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return Result.success(null);
    } catch (e) {
      AppLogger.error('SignOut failed', 'AuthRepository', e);
      return Result.failure(const ServerFailure('Failed to sign out. Please try again.'));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() => _remoteDataSource.getCurrentUser();

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges;
}