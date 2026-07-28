import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

// saare auth related kaam
// GoRouter bhi isi ko listen karega : RefreshListenable
class AuthProvider extends ChangeNotifier {
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthProvider({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _signUpUseCase = signUpUseCase,
        _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase {
    _checkInitialAuthState();
  }

  ViewStatus _status = ViewStatus.initial;
  ViewStatus get status => _status;
  bool _isCheckingAuth = true;
  bool get isCheckingAuth => _isCheckingAuth;
  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  Future<void> _checkInitialAuthState() async {
    try {
      _currentUser = await _getCurrentUserUseCase();
    } catch (e) {
      AppLogger.error('Failed to check initial auth state', 'AuthProvider', e);
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    final result = await _signUpUseCase(name: name, email: email, password: password);
    return result.fold(
          (Failure failure) {
        _setError(failure.message);
        return false;
      },
          (UserEntity user) {
        _currentUser = user;
        _setSuccess();
        return true;
      },
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading();
    final result = await _signInUseCase(email: email, password: password);
    return result.fold(
          (Failure failure) {
        _setError(failure.message);
        return false;
      },
          (UserEntity user) {
        _currentUser = user;
        _setSuccess();
        return true;
      },
    );
  }

  Future<void> signOut() async {
    _setLoading();
    final result = await _signOutUseCase();
    result.fold(
          (Failure failure) => _setError(failure.message),
          (_) {
        _currentUser = null;
        _setSuccess();
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = ViewStatus.success;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = ViewStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}