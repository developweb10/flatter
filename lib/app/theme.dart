import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primaryColorDark: Colors.white,
  primaryColor: Colors.grey[900],
  primaryColorLight: Colors.grey[400],
  brightness: Brightness.dark,
  //backgroundColor: const Color(0xFF212121),
  backgroundColor: Colors.grey[800],
  accentColor: Colors.white,
  bottomAppBarColor: Colors.grey[900],
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
  dividerColor: Colors.white,
);

final backgroundDecoration = BoxDecoration(
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
final lightTheme = ThemeData(
  primaryColorDark: Colors.blue,
  primaryColor: Colors.redAccent,
  primaryColorLight: Colors.redAccent[100],
  brightness: Brightness.light,
  //backgroundColor: Colors.white,
  accentColor: Color(0xFFFEF9EB),
  bottomAppBarColor: Colors.white,
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
  dividerColor: Colors.grey,
);

final finalTheme = ThemeData(
                      fontFamily: 'ProductSans',
                      primaryColor: Colors.redAccent,
                      backgroundColor: Color(0xffF2F2F2),
                      floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                      brightness: Brightness.light,
                      accentColor: Color(0xFFfe4a49),
                      dividerColor: Color(0xFFfe4a49).withOpacity(0.1),
                      focusColor: Colors.black,
                      hintColor: Colors.black,
                        primaryColorDark: Colors.blue,
                      bottomAppBarColor: Colors.white,
                      bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
                      textTheme: TextTheme(
                        headline6: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.black, height: 1.2),
                        headline5: TextStyle(fontSize: 22.0, color: Colors.black, height: 1.3),
                        headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.1),
                        headline3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
                        headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
                        headline1: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.4),
                        subtitle1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300, color: Colors.black, height: 1.3),
                        subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: Colors.black.withOpacity(0.5), height: 1.2),

                        bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black, height: 1.2),
                        bodyText1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black, height: 1.2),
                        caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.black, height: 1.2),
                      ),
                    );