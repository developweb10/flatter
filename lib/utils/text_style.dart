import 'package:flutter/material.dart';

txtStyle(Color color, double forntSize) {
  return TextStyle(
    color: color,
    fontSize: forntSize,
  );
}

txtStyleWithBold(Color color, double forntSize) {
  return TextStyle(
    color: color,
    fontSize: forntSize,
  );
}

txtStyleWithShadow(Color color, double forntSize) {
  return TextStyle(
    color: color,
    fontSize: forntSize,
    fontWeight: FontWeight.bold,
    shadows: [
      txtShadow(),
    ],
  );
}

txtShadow() {
  return BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.15),
    offset: Offset(0, 5),
    blurRadius: 10.0,
  );
}
