import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const MenuItem({Key key, this.icon, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(wp(4)),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Color(0xFFFEF9EB),
              size: wp(8),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 26,
                  color: Color(0xFFFFFFFF)),
            )
          ],
        ),
      ),
    );
  }
}
