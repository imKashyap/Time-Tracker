import 'package:flutter/material.dart';
import 'package:timetracker/cmn_widgets/custom_raised_button.dart';

class SubmitButton extends CustomRaisedButton {
   SubmitButton({@required VoidCallback onPressed, String text})
      : super(
        onPressed:onPressed, 
          child: Text(text,
          style: TextStyle(color: Colors.white,
          fontSize: 20.0),),
          color:Colors.indigo,
          height:44.0,
          borderRadius:4.0
        );
}
