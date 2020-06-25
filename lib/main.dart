import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/pages/landing_page.dart';
import 'package:timetracker/sevices/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(
        ),
      ),
    );
  }
}
