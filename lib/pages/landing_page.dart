import 'package:flutter/material.dart';
import 'package:timetracker/pages/signin_page/signin_page.dart';
import 'package:timetracker/sevices/auth.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.auth});
  AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.getCurrentAuthState(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // if (snapshot.hasData) {
            final User thisUser = snapshot.data;
            if (thisUser != null)
              return HomePage(
                auth: auth,
              );
            else
              return SignInPage(
                auth: auth,
              );
          //}
          //  else {
          //   final error = snapshot.error;
          //   print(error);
          //   return Container();
          // }
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
