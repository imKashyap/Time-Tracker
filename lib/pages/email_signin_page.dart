import 'package:flutter/material.dart';
import 'package:timetracker/pages/signin_page/email_signin_form.dart';
import 'package:timetracker/sevices/auth.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase auth;
  const EmailSignInPage(this.auth);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Sign In'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
                  child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(child: EmailSignInForm(auth))),
        ));
  }
}
