import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final double height;
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  final Color color;
  const CustomRaisedButton({
    @required this.child,
    @required this.onPressed,
    this.height: 50.0,
    this.borderRadius: 4.0,
    this.color: Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}
