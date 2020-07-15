import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetracker/sevices/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signInMethod(Future<User> Function() signInWith) async {
    try {
     isLoading.value=true;
      return await signInWith();
    } catch (e) {
      isLoading.value=false;
      rethrow;
    }
  }

  Future<User> signInAnonymously()async =>await _signInMethod(auth.signInAnonymously);

  Future<User> signInWithGoogle()async =>await _signInMethod(auth.signInWithGoogle);

  Future<User> signInWithFb()async =>await _signInMethod(auth.signInWithFb);

}
