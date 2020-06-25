import 'package:flutter/material.dart';
import 'package:timetracker/pages/signin_page/email_signin_form.dart';

class EmailSignInPage extends StatelessWidget {
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
              child: Card(child: EmailSignInForm())),
        ));
  }
}
