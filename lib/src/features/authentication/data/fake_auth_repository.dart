import 'dart:async';

import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChange();
  AppUser? get currentUser;
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  void dispose();

  void _createNewUser({required String email});
}

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);
  @override
  Stream<AppUser?> authStateChange() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (currentUser == null) {
      _createNewUser(email: email);
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (currentUser == null) {
      _createNewUser(email: email);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 3));
    throw Exception("Connection failed");
    _authState.value = null;
  }

  @override
  void _createNewUser({required String email}) {
    _authState.value =
        AppUser(uid: email.split('').reversed.join(''), email: email);
  }

  @override
  void dispose() {
    _authState.close();
  }
}

class FirebaseAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> authStateChange() {
    // TODO: implement authStateChange
    throw UnimplementedError();
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AppUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  void _createNewUser({required String email}) {
    // TODO: implement _createNewUser
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  // const bool isFake=String.fromEnvironment("useFakeRepos")=="true";
  // return isFake? FakeAuthRepository():FirebaseAuthRepository();
  final auth = FakeAuthRepository();
  ref.onDispose(() {
    auth.dispose();
  });
  return auth;
});
final authStateChangeProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChange();
});
