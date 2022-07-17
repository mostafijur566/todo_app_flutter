import 'package:flutter/material.dart';

const Color blushClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFffb746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color primaryClr = blushClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes{

  static final light = ThemeData(
      colorScheme: ColorScheme.light().copyWith(primary: primaryClr),
    brightness: Brightness.light
  );

  static final dark = ThemeData(
      colorScheme: ColorScheme.dark().copyWith(primary: darkGreyClr),
      brightness: Brightness.dark
  );
}