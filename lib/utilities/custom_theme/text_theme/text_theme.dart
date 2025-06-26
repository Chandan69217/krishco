import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';


class TTextTheme {
  TTextTheme._();

  static const TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily:'roboto',
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'roboto',
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'roboto',
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontFamily:'roboto',
      color: Colors.black,
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      fontFamily:'roboto',
      color: Colors.black,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      fontFamily:'roboto',
      color: Colors.black,
      fontSize: 14,
    ),
    titleLarge: TextStyle(
      fontFamily:'roboto',
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontFamily:'roboto',
      color: Colors.black,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      fontFamily:'roboto',
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  );

  static const TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily:'roboto',
      color: CustColors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 14,
    ),
    titleLarge: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      fontFamily:'roboto',
      color:  CustColors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  );
}
