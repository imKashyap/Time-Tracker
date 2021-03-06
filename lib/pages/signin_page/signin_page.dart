import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/cmn_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/pages/signin_page/sign_in_manager.dart';
import 'package:timetracker/pages/signin_page/signin_button.dart';
import 'package:timetracker/sevices/auth.dart';

import 'email_sign_in/email_signin_page.dart';

class SignInPage extends StatelessWidget {
   const SignInPage({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

 void showErrorDialog(BuildContext context, PlatformException e) {
    PlatfromrExceptionAlertDialog(title: 'Sign In Failed', e: e).show(context);
  }

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
      body:  _buildContents(spaceBox, context,),
    );
  }

  Padding _buildContents(
      SizedBox spaceBox, BuildContext context) {
    return Padding(
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
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
            color: Colors.white,
            textColor: Colors.black,
          ),
          spaceBox,
          SignInButton(
            icon: Image.asset('assets/images/facebook-logo.png'),
            signInText: 'Sign in with Facebook',
            onPressed: isLoading ? null : () => _signInWithFb(context),
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
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            textColor: Colors.black,
            icon: SizedBox(),
          ),
          spaceBox,
          spaceBox,
          _buildFooter(isLoading),
        ],
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') showErrorDialog(context, e);
    } 
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') showErrorDialog(context, e);
    }
  }

  Future<void> _signInWithFb(BuildContext context) async {
    try {
      await manager.signInWithFb();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') showErrorDialog(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true, builder: (context) => EmailSignInPage()));
  }

  Widget _buildFooter(bool isLoading) {
    if (isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Container();
  }
}
