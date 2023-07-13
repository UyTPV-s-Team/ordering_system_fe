import 'package:flutter/material.dart';
class LegendItemWidget extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItemWidget({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: color,
        height: 40,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
