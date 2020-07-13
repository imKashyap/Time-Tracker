import 'dart:async';
import 'package:timetracker/pages/signin_page/email_sign_in/email_sign_in_model.dart';
import 'package:timetracker/sevices/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;
  EmailSignInBloc(this.auth);

  StreamController<EmailSignInModel> _emailSignInController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get emailSignInStream =>
      _emailSignInController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _emailSignInController.close();
  }
  
  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith(
      {String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool isSubmitted}) {
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        isSubmitted: isSubmitted);
    _emailSignInController.add(_model);
  }

    void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.signUp
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      isSubmitted: false,
    );
  }

  void submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.loginWithEmail(_model.email, _model.password);
      } else {
        await auth.signUpWithEmail(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
