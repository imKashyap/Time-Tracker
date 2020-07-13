import 'package:timetracker/validators/form_validator.dart';
enum EmailSignInFormType { signIn, signUp }

class EmailSignInModel with EmailPassValidator {
  final String email;
  final String password;
  final bool isLoading;
  final EmailSignInFormType formType;
  final bool isSubmitted;

  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.isSubmitted = false,
  });

  EmailSignInModel copyWith(
      {String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool isSubmitted}) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

   String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passValidator.isValid(password) &&
        !isLoading;
  }

  String get passErrorText {
    bool showErrorText =
        isSubmitted && !passValidator.isValid(password);
    return showErrorText ? passError : null;
  }

  String get emailErrorText {
    bool showErrorText = isSubmitted && !emailValidator.isValid(email);
    return showErrorText ? emailError: null;
  }
}
