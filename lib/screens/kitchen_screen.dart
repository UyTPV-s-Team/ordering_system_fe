import 'package:flutter/material.dart';
import 'package:ordering_system_fe/templates/base_widget.dart';

class KitchenScreen extends StatefulWidget {
  static const String screenName = 'kitchen_screen';

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Image(
                    image: ResizeImage(
                      AssetImage(
                        'images/yourlogo-white.png',
                      ),
                      height: 80,
                      width: 80,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      'ORDERING SYSTEM',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                onPressed: () {},
                child: Icon(
                  Icons.location_city,
                  size: 50.0,
                ),
              ),
            ],
          ),
          Text('ád'),
          Text('ád'),
        ],
      ),
    );
  }
}
