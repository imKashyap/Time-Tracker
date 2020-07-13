import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/cmn_widgets/platform_alert_dialog.dart';
import 'package:timetracker/cmn_widgets/submit_button.dart';
import 'package:timetracker/sevices/auth.dart';
import 'package:timetracker/validators/form_validator.dart';

import 'email_sign_in_model.dart';

class EmailSignInForm extends StatefulWidget with EmailPassValidator {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _passFocusNode = FocusNode();
  EmailSignInFormType _signInFormState = EmailSignInFormType.signIn;
  String get _email => _emailController.text;
  String get _password => _passController.text;
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: signInForm(),
      ),
    );
  }

  List<Widget> signInForm() {
    const spaceBox = SizedBox(
      height: 10.0,
    );
    return [
      _buildEmailTextField(),
      spaceBox,
      _buildPasswordTextField(),
      spaceBox,
      spaceBox,
      SubmitButton(
        onPressed: (widget.emailValidator.isValid(_email) &&
                widget.emailValidator.isValid(_password))
            ? _submit
            : null,
        text: _signInFormState == EmailSignInFormType.signIn
            ? 'Sign In'
            : 'Create an Account',
      ),
      spaceBox,
      FlatButton(
          onPressed: toggleFormState,
          child: Text(_signInFormState == EmailSignInFormType.signIn
              ? 'Need an Account? Register.'
              : 'Have an Account? Login instead.')),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _isSubmitted && widget.passValidator.isValid(_password);
    return TextField(
        onChanged: (value) => _updateState(),
        onEditingComplete: _submit,
        focusNode: _passFocusNode,
        textInputAction: TextInputAction.done,
        controller: _passController,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          errorText: showErrorText ? null : widget.passError,
          labelText: 'Password',
        ));
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _isSubmitted && widget.emailValidator.isValid(_email);
    return TextField(
      autofocus: true,
      onChanged: (value) => _updateState(),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passFocusNode),
      textInputAction: TextInputAction.next,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          errorText: showErrorText ? null : widget.emailError,
          labelText: 'Email',
          hintText: 'you@example.com'),
    );
  }

  void _submit() async {
    try {
      setState(() {
        _isSubmitted = true;
      });
      final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
      if (_signInFormState == EmailSignInFormType.signIn) {
        await auth.loginWithEmail(_email, _password);
      } else {
        await auth.signUpWithEmail(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      PlatformAlertDialog(
              title: 'Sign in Failed',
              content: e.message,
              defaultActionText: 'OK')
          .show(context);
    }
  }

  void _updateState() {
    setState(() {});
  }

  void toggleFormState() {
    setState(() {
      _isSubmitted = false;
      _signInFormState = _signInFormState == EmailSignInFormType.signUp
          ? EmailSignInFormType.signIn
          : EmailSignInFormType.signUp;
    });
    _emailController.clear();
    _passController.clear();
  }

  @override
  void dispose() {
    _passFocusNode.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
