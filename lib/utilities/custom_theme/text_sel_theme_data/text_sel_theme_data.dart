import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';


class TTextSelectionThemeData{
  TTextSelectionThemeData._();

  static final TextSelectionThemeData light = TextSelectionThemeData(
      // selectionHandleColor: CustColors.RED,
      selectionColor: CustColors.primary,
    cursorColor: CustColors.nile_blue
  );

  static final TextSelectionThemeData dark = TextSelectionThemeData(
      // selectionHandleColor: ColorTheme.RED,
      selectionColor: Colors.grey,
      cursorColor: CustColors.nile_blue
  );
}