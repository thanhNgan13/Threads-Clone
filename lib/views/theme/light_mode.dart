import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white, // Change the background color to white
    primary: Colors.white, // Change the primary color to blue
    secondary: Colors.grey, // Change the secondary color to grey
    onPrimary: Colors.black, // Change the text color on primary color to black
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black, // Change the body text color to black
        displayColor: Colors.black, // Change the display text color to black
      ),
);
