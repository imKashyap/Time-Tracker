import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/pages/signin_page/signin_page.dart';
import 'package:timetracker/sevices/auth.dart';


import 'home_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
      stream: auth.getCurrentAuthState(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User thisUser = snapshot.data;
          if (thisUser != null)
            return HomePage(
            );
          else
            return SignInPage(
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
