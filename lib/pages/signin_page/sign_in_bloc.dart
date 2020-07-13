import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetracker/sevices/auth.dart';

class SignInBloc {
  final AuthBase auth;
  final StreamController<bool> isLoadingController = StreamController<bool>();

  SignInBloc({@required this.auth});

  Stream<bool> get isLoadingStream => isLoadingController.stream;

  void _setIsLoading(bool value) {
    isLoadingController.add(value);
  }

  void dispose() {
    isLoadingController.close();
  }

  Future<User> _signInMethod(Future<User> Function() signInWith) async {
    try {
      _setIsLoading(true);
      return await signInWith();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInAnonymously()async =>await _signInMethod(auth.signInAnonymously);

  Future<User> signInWithGoogle()async =>await _signInMethod(auth.signInWithGoogle);

  Future<User> signInWithFb()async =>await _signInMethod(auth.signInWithFb);

}
