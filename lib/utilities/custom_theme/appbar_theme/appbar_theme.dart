import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';

class TAppbarTheme{
  TAppbarTheme._();

  static final AppBarTheme lightAppbarTheme = AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: CustColors.nile_blue,
      iconTheme: IconThemeData(
          color: Colors.white
      )
  );

  static final AppBarTheme darkAppbarTheme = AppBarTheme(
      backgroundColor: Colors.black,
    iconTheme: IconThemeData(
      color: CustColors.white
    )
  );
}