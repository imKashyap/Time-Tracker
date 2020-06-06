import 'package:flutter/material.dart';
import 'package:timetracker/pages/signin_page/signin_page.dart';
import 'package:timetracker/sevices/auth.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({@required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.getCurrentAuthState(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
            final User thisUser = snapshot.data;
            if (thisUser != null)
              return HomePage(
                auth: auth,
              );
            else
              return SignInPage(
                auth: auth,
              );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
