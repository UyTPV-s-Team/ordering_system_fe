import 'package:flutter/material.dart';
import 'package:ordering_system_fe/components/big_button.dart';
import 'package:ordering_system_fe/screens/kitchen_screen.dart';
import 'package:ordering_system_fe/screens/ready_screen.dart';
import 'package:ordering_system_fe/screens/waiting_screen.dart';
import 'package:ordering_system_fe/templates/base_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String screenName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BigButton(
              btnLabel: 'KITCHEN',
              btnBackgroundColor: Color(0xff3E83A2),
              onPressed: () {
                Navigator.pushNamed(context, KitchenScreen.screenName);
              },
            ),
            BigButton(
              btnLabel: 'READY',
              btnBackgroundColor: Color(0xff241417),
              onPressed: () {
                Navigator.pushNamed(context, ReadyScreen.screenName);
              },
            ),
            BigButton(
              btnLabel: 'WAITING',
              btnBackgroundColor: Color(0xff389B3A),
              onPressed: () {
                Navigator.pushNamed(context, WaitingScreen.screenName);
              },
            ),
          ],
        ),
      ),
    );
  }
}


