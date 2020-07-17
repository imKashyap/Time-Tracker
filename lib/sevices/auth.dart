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
  Future<User> signUpWithEmail(String email, String password);
  Future<User> loginWithEmail(String email, String password);
  Future<User> signInWithFb();
  Future<void> signOut();
  Future<String> verifyPhone(String phoneNo);
  Future<User> signInWithPhone(String verId, String smsCode);
}

class Auth implements AuthBase {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _fbLogin = FacebookLogin();

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
  Future<User> signUpWithEmail(String email, String password) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _getUserFromFirebase(authResult.user);
  }

  @override
  Future<User> loginWithEmail(String email, String password) async {
    AuthResult authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return _getUserFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
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
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKENS',
            message: 'Google auth tokens are missing');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User> signInWithFb() async {
    final result = await _fbLogin.logIn(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final AuthResult authResult =
          await _auth.signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      ));
      return _getUserFromFirebase(authResult.user);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<void> signOut() async {
    await _fbLogin.logOut();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<String> verifyPhone(String phoneNo) async {
    String verificationId;
    final PhoneVerificationCompleted verified =
        (AuthCredential authCredential) async {
      await _auth.signInWithCredential(authCredential);
    };
    final PhoneVerificationFailed verificationFailed = (AuthException e) {
      print(e.message);
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      verificationId = verId;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+91$phoneNo",
          timeout: Duration(seconds: 60),
          verificationCompleted: verified,
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);
      return verificationId;
    } catch (e) {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User> signInWithPhone(String verId, String smsCode) async {
    User loggedInUser;
    _auth.currentUser().then((user) async {
      if (user != null)
        loggedInUser = _getUserFromFirebase(user);
      else {
        final AuthCredential authCreds = PhoneAuthProvider.getCredential(
            verificationId: verId, smsCode: smsCode);
        try {
          final AuthResult authResult =
              await _auth.signInWithCredential(authCreds);
          loggedInUser = _getUserFromFirebase(authResult.user);
        } catch (e) {
          rethrow;
        }
      }
    });
    return loggedInUser;
  }
}
