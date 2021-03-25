import 'package:flutter/material.dart';

containerShapeWithOpcitiy(double radius) {
  return BoxDecoration(
    color: Color.fromRGBO(255, 255, 255, 1.9),
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
  );
}

containerShape(Color color, double radius) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
  );
}

containerShapeWithShadow(double radius) {
  return BoxDecoration(
    gradient: LinearGradient(colors: [
      Color.fromRGBO(229, 87, 54, 1),
      Color.fromRGBO(229, 87, 54, 1),
      Color.fromRGBO(229, 87, 54, 1),
    ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0, 5),
        blurRadius: 10.0,
      )
    ],
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
  );
}

//containerShapeWithInnerShadow(double radius) {
//  return BoxDecoration(
//    color: Colors.transparent,
//    boxShadow: [
//      const BoxShadow(
//        color: your_shadow_color,
//        offset: const Offset(0.0, 0.0),
//      ),
//      const BoxShadow(
//        color: your_bg_color,
//        offset: const Offset(0.0, 0.0),
//        spreadRadius: -12.0,
//        blurRadius: 12.0,
//      ),
//    ],
//  );
//}

colrs() {
  return [
    Color(0xFFff6060),
    Color(0xFFff6060),
    Color(0xFFfe4a49),
    Color(0xFFfe4a49),
  ];
}

backgroudColor() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.4, 0.7, 0.9],
      colors: [
        Color(0xFFff6060),
        Color(0xFFff6060),
        Color(0xFFfe4a49),
        Color(0xFFfe4a49),
      ],
    ),
  );
}

loginButtonShape() {
  return BoxDecoration(
    gradient: LinearGradient(colors: [
      Color.fromRGBO(229, 87, 54, 1),
      Color.fromRGBO(229, 87, 54, 1),
      Color.fromRGBO(229, 87, 54, 1),
    ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0, 5),
        blurRadius: 10.0,
      )
    ],
    borderRadius: BorderRadius.circular(9.0),
  );
}

cardShape(double radius) {
  return RoundedRectangleBorder(
    // side: BorderSide(color: Colors.white70, width: 1),
    borderRadius: BorderRadius.circular(radius),
  );
}

cardShapeFromTop(double radius) {
  return RoundedRectangleBorder(
    // side: BorderSide(color: Colors.white70, width: 1),
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
  );
}
