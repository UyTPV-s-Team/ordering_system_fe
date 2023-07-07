import 'dart:ui';

import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  final child;

  const BaseWidget({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff12161B),
              Color(0xff0F4539),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
