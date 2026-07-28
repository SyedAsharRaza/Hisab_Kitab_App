import 'package:firebase_auth/firebase_auth.dart';
import '../logger/logger_service.dart';

//wrapper around FirebaseAuth
class FirebaseAuthService {
  final FirebaseAuth _auth;
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign up failed: ${e.code}', 'FirebaseAuth', e);
      rethrow;
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in failed: ${e.code}', 'FirebaseAuth', e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      AppLogger.error('Sign out failed', 'FirebaseAuth', e);
      rethrow;
    }
  }

  Future<void> updateDisplayName(String name) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
    } catch (e) {
      AppLogger.error('Failed to update display name', 'FirebaseAuth', e);
    }
  }
}