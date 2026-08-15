import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';


abstract class AuthRemoteDataSource {
  Future<UserCredential> signUp(String email, String password);
  Future<UserCredential> login(String email, String password);
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Failure(e.message ?? 'Sign up failed', code: e.code);
    } catch (e) {
      throw Failure('An unexpected error occurred during sign up.');
    }
  }

  @override
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Failure(e.message ?? 'Login failed', code: e.code);
    } catch (e) {
      throw Failure('An unexpected error occurred during login.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Failure(e.message ?? 'Sign out failed', code: e.code);
    } catch (e) {
      throw Failure('An unexpected error occurred during sign out.');
    }
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}