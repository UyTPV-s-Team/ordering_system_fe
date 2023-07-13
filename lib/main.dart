import 'package:flutter/material.dart';
import 'package:ordering_system_fe/screens/home_screen.dart';
import 'package:ordering_system_fe/screens/kitchen_screen.dart';
import 'package:ordering_system_fe/screens/ready_screen.dart';
import 'package:ordering_system_fe/screens/waiting_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        // textTheme: GoogleFonts.robotoTextTheme(),// Áp dụng font Roboto cho tất cả các TextTheme
      ),

      initialRoute: HomeScreen.screenName,
      routes: {
        HomeScreen.screenName: (context) => HomeScreen(),
        KitchenScreen.screenName: (context) => KitchenScreen(),
        ReadyScreen.screenName: (context) => ReadyScreen(),
        WaitingScreen.screenName: (context) => WaitingScreen(),
      },
    );
  }
}
