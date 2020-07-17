import 'package:flutter/material.dart';
import 'package:timetracker/sevices/auth.dart';
import 'package:timetracker/validators/form_validator.dart';

class PhoneSignInModel with EmailPassValidator, ChangeNotifier {
  String phone;
  String smsCode;
  String verId;
  bool codeSent;
  bool isLoading;
  bool isSubmitted;
  final AuthBase auth;

  PhoneSignInModel({
    @required this.auth,
    this.smsCode = '',
    this.verId = '',
    this.phone = '',
    this.codeSent = false,
    this.isLoading = false,
    this.isSubmitted = false,
  });

  void submit() async {
    updateWith(isSubmitted: true, isLoading: true, codeSent: true);
    try {
      final String verId = await auth.verifyPhone(phone);
      updateVerId(verId);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  Future<void> verifyOtp() async {
    updateWith( isLoading: true);
    try {
      await auth.signInWithPhone(verId, smsCode);
    } catch (e) {
      updateWith(isLoading: false);
    }
  }

  void updatePhone(String phone) => updateWith(phone: phone);
  void updateSmsCode(String smsCode) => updateWith(smsCode: smsCode);
  void updateVerId(String verId) => updateWith(verId: verId);

  void updateWith(
      {String phone,
      String verId,
      String smsCode,
      bool codeSent,
      bool isLoading,
      bool isSubmitted}) {
    this.phone = phone ?? this.phone;
    this.verId = verId ?? this.verId;
    this.smsCode = smsCode ?? this.smsCode;
    this.codeSent = codeSent ?? this.codeSent;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
  }

  bool get canSubmit {
    return phoneValidator.isValidPhone(phone) && !isLoading;
  }

  String get phoneErrorText {
    bool showErrorText = isSubmitted && !phoneValidator.isValidPhone(phone);
    return showErrorText ? phoneError : null;
  }
}
