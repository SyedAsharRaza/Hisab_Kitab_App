
// base class sare failures ke lie take usecase/repositories raw exceptions nhi throw karen and instead in Failures ko use karen
// take errors readable ho and User friendly ho

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load local data.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Firebase Exceptions ko AuthFailure me convert karna


class AuthFailureMapper {
  static AuthFailure fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const AuthFailure('This email is already registered.');
      case 'invalid-email':
        return const AuthFailure('Please enter a valid email address.');
      case 'weak-password':
        return const AuthFailure('Password should be at least 6 characters.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AuthFailure('Incorrect email or password.');
      case 'user-disabled':
        return const AuthFailure('This account has been disabled.');
      case 'too-many-requests':
        return const AuthFailure('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return const AuthFailure('No internet connection. Please check your network.');
      default:
        return const AuthFailure('Something went wrong. Please try again.');
    }
  }
}