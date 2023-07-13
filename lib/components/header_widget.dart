import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
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
          color: Color(0xffF24E40),
          height: 80,
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
