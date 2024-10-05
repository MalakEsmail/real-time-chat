import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User?> login({required String email, required String password});

  Future<User?> signUp({required String email, required String password});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<User?> login({required String email, required String password}) async {
    final result = await auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  @override
  Future<User?> signUp({required String email, required String password}) async {
    final result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
