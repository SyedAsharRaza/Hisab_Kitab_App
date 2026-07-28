import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

// abstract class and iska contract iski extending class ko fulfill karna hoga
abstract class AuthRepository {
  Future<Result<UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  });
  Future<Result<void>> signOut();

  // null agar koi signed in nhi hay
  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
}