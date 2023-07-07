import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  String btnLabel;
  Color btnBackgroundColor;
  var onPressed;

  BigButton(
      {required this.btnLabel,
      required this.btnBackgroundColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(50),
            backgroundColor: btnBackgroundColor,
          ),
          onPressed: onPressed,
          child: Text(
            btnLabel,
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
