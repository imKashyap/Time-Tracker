import 'package:flutter/material.dart';
import 'package:timetracker/cmn_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required Widget icon,
    @required String signInText,
    @required Color color,
    @required Color textColor,
    @required Function onPressed,
  }) : super(
          color: color,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              icon,
              Text(
                signInText,
                style: TextStyle(color: textColor,
                fontSize: 20.0),
              ),
              Opacity(opacity: 0.0, child: icon),
            ],
          ),
        );
}
