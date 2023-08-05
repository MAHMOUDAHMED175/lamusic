import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/utils/colors.dart';
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.orange,
  hintColor: Colors.grey[200],
  scaffoldBackgroundColor: ColorsApp.greyColor,
  textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
  appBarTheme:  AppBarTheme(
    color: Colors.grey[200],
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.grey[200],
      systemNavigationBarColor: Colors.grey[200],
    ),
    titleSpacing: 16.0,
    titleTextStyle: TextStyle(
      fontSize: 16.0,
      fontStyle: FontStyle.italic,
    ),
  ),
  buttonTheme: ButtonThemeData(
    height: 60,
    buttonColor: Colors.orange,
    splashColor: Colors.orange,
    highlightColor: Colors.orange,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    focusColor: Colors.orange,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
    elevation: 5.0,
    shape: CircleBorder(),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.orange),
  focusColor: Colors.orange,
  dialogBackgroundColor: Colors.white,
);

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.adamina().fontFamily,
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  hintColor: Colors.grey[200],
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ),
    titleSpacing: 16.0,
    titleTextStyle: TextStyle(
      fontSize: 16.0,
      fontStyle: FontStyle.italic,
    ),
  ),
  buttonTheme: ButtonThemeData(
    height: 60,
    buttonColor: Colors.orange,
    splashColor: Colors.orange,
    highlightColor: Colors.orange,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    focusColor: Colors.orange,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.black,
    elevation: 5.0,
    shape: CircleBorder(),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.orange),
  focusColor: Colors.orange,
  dialogBackgroundColor: Colors.black,
);
