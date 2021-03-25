import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionPainterRed extends CustomClipper<Path> {

 @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.moveTo(0, size.height*0.02);
    path.lineTo(0, size.height /2);
    var firstControlPoint = new Offset(size.width / 4, size.height / 2.5);
    var firstEndPoint = new Offset(size.width / 2, size.height /2 );
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height - (size.height / 2.5));
    var secondEndPoint = new Offset(size.width, size.height /2);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height*0.02);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) 
  {
    return false;
  }
}