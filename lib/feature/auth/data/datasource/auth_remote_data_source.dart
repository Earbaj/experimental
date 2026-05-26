import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password, String name);
  Future<void> signOut();
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credentials = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user == null) {
        throw Exception('User is null after signing in.');
      }
      return UserModel.fromFirebaseUser(credentials.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      final credentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user == null) {
        throw Exception('User is null after registration.');
      }
      await credentials.user!.updateDisplayName(name);
      await credentials.user!.reload();
      final updatedUser = firebaseAuth.currentUser;
      return UserModel.fromFirebaseUser(updatedUser ?? credentials.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() {
    return firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> get authStateChanges =>
      firebaseAuth.authStateChanges().map((fb.User? user) {
        return user != null ? UserModel.fromFirebaseUser(user) : null;
      });

  @override
  UserModel? get currentUser {
    final user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}
