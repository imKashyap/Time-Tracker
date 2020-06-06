import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;
  const User({@required this.uid});
}

abstract class AuthBase {
  Stream<User> getCurrentAuthState();
  //Future<User> getCurrentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFb();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final fbLogin = FacebookLogin();

  User _getUserFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  @override
  Stream<User> getCurrentAuthState() {
    return _auth.onAuthStateChanged.map((user) => _getUserFromFirebase(user));
  }

  // @override
  // Future<User> getCurrentUser() async {
  //   FirebaseUser user = await _auth.currentUser();
  //   return _getUserFromFirebase(user);
  // }

  @override
  Future<User> signInAnonymously() async {
    AuthResult authResult = await _auth.signInAnonymously();
    return _getUserFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthResult authResult = await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return _getUserFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING GOOGLE AUTH TOKENS',
            message: 'Google auth tokens are missing');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED BY USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User> signInWithFb() async {
    final result = await fbLogin.logIn(
      ['public_profile'],
    );
    if (result.accessToken != null) {
    final AuthResult authResult= await  _auth.signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      ));
      return _getUserFromFirebase(authResult.user);
    }
    else {
      throw PlatformException(
          code: 'ERROR_ABORTED BY USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<void> signOut() async {
    await fbLogin.logOut();
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
