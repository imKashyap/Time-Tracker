import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/cmn_widgets/platform_alert_dialog.dart';
import 'package:timetracker/sevices/auth.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    bool didRequestSignOut = await PlatformAlertDialog(
            cancelActionText: 'Cancel',
            title: 'Logout',
            content: 'Are you sure?',
            defaultActionText: 'OK')
        .show(context);
    if (didRequestSignOut == true) _signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Container(
        child: Center(
            child: Text(
          'Hello World',
          style: TextStyle(fontSize: 40.0),
        )),
      ),
    );
  }
}
