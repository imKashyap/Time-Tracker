import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User {
  final String uid;
  const User({@required this.uid});
}

abstract class AuthBase {
  Stream<User> getCurrentAuthState();
  Future<User> getCurrentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _auth = FirebaseAuth.instance;
  User _getUserFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  @override
  Stream<User> getCurrentAuthState() {
    return _auth.onAuthStateChanged.map((user) => _getUserFromFirebase(user));
  }

  @override
  Future<User> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return _getUserFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    AuthResult authResult = await _auth.signInAnonymously();
    return _getUserFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
