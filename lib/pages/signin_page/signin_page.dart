import 'package:flutter/material.dart';
import 'package:timetracker/pages/signin_page/signin_button.dart';
import 'package:timetracker/sevices/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    const spaceBox = const SizedBox(
      height: 10.0,
    );
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign In',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30.0),
            ),
            spaceBox,
            spaceBox,
            SignInButton(
              icon: Image.asset('assets/images/google-logo.png'),
              signInText: 'Sign in with Google',
              onPressed: () {},
              color: Colors.white,
              textColor: Colors.black,
            ),
            spaceBox,
            SignInButton(
              icon: Image.asset('assets/images/facebook-logo.png'),
              signInText: 'Sign in with Facebook',
              onPressed: () {},
              color: Colors.blue[900],
              textColor: Colors.white,
            ),
            spaceBox,
            SignInButton(
              icon: Icon(
                Icons.mail,
                color: Colors.white,
                size: 35.0,
              ),
              signInText: 'Sign in with email',
              onPressed: () {},
              color: Colors.teal,
              textColor: Colors.white,
            ),
            spaceBox,
            Text(
              'Or',
              style: TextStyle(fontSize: 20.0),
            ),
            spaceBox,
            SignInButton(
              color: Colors.lime,
              signInText: 'Maybe Later',
              onPressed:_signInAnonymously,
              textColor: Colors.black,
              icon: SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signInAnonymously() async {
    try {
          await auth.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }
}
