abstract class StringValidator {
  bool isValid(String value);
  bool isValidPhone(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  @override
  bool isValidPhone(String value) {
    return value.length == 10;
  }
}

class EmailPassValidator {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passValidator = NonEmptyStringValidator();
  final StringValidator phoneValidator = NonEmptyStringValidator();
  final String emailError = 'Email field can\'t be empty.';
  final String passError = 'Password can\'t be empty.';
  final String phoneError = 'Please provide a valid 10 digit phone number';
}
