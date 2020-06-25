import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/cmn_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/pages/email_signin_page.dart';
import 'package:timetracker/pages/signin_page/signin_button.dart';
import 'package:timetracker/sevices/auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  showErrorDialog(BuildContext context, PlatformException e) {
    PlatfromrExceptionAlertDialog(title: 'Sign In Failed', e: e).show(context);
  }

  bool _isLoading = false;

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
              onPressed: _isLoading ? null : () => _signInWithGoogle(context),
              color: Colors.white,
              textColor: Colors.black,
            ),
            spaceBox,
            SignInButton(
              icon: Image.asset('assets/images/facebook-logo.png'),
              signInText: 'Sign in with Facebook',
              onPressed: _isLoading ? null : () => _signInWithFb(context),
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
              onPressed: _isLoading ? null : () => _signInWithEmail(context),
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
              onPressed: _isLoading ? null : () => _signInAnonymously(context),
              textColor: Colors.black,
              icon: SizedBox(),
            ),
            spaceBox,
            spaceBox,
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthBase auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') showErrorDialog(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthBase auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') showErrorDialog(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithFb(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthBase auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFb();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') showErrorDialog(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true, builder: (context) => EmailSignInPage()));
  }

  Widget _buildFooter() {
    if (_isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Container();
  }
}
