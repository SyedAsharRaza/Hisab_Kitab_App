import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase/firebase_auth_service.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../models/user_model.dart';

// firebas auth and firestore se direct baat
class AuthRemoteDataSource {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;
  AuthRemoteDataSource({
    required FirebaseAuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService;
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signUp(email: email, password: password);
    final uid = credential.user!.uid;
    await _authService.updateDisplayName(name);
    final userModel = UserModel(uid: uid, email: email, name: name);
    // profile store karli take user data show karun and Firebase currentUser ko use na karna pare
    await _firestoreService.setDocument(
      collectionPath: AppConstants.usersCollection,
      docId: uid,
      data: userModel.toMap(),
    );
    return userModel;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signIn(email: email, password: password);
    final uid = credential.user!.uid;
    return _fetchUserProfile(uid, fallbackEmail: email);
  }
  Future<void> signOut() => _authService.signOut();
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return null;
    return _fetchUserProfile(firebaseUser.uid, fallbackEmail: firebaseUser.email ?? '');
  }

  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) return null;
      return _fetchUserProfile(firebaseUser.uid, fallbackEmail: firebaseUser.email ?? '');
    });
  }

  Future<UserModel> _fetchUserProfile(String uid, {required String fallbackEmail}) async {
    try {
      final doc = await _firestoreService
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) { // agar user data exist karta ho to
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      AppLogger.warning('Failed to fetch user profile doc, using fallback', 'AuthRemote');
    }
    // warna fallback agar profile document missing ho
    return UserModel(uid: uid, email: fallbackEmail, name: '');
  }
}