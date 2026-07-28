import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;
  const SignOutUseCase(this.repository);

  Future<Result<void>> call() {
    return repository.signOut();
  }
}