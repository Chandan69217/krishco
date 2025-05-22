import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';

class TAppbarTheme{
  TAppbarTheme._();

  static final AppBarTheme lightAppbarTheme = AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: CustColors.nile_blue,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
      iconTheme: IconThemeData(
          color: Colors.white
      )
  );

  static final AppBarTheme darkAppbarTheme = AppBarTheme(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
    iconTheme: IconThemeData(
      color: CustColors.white
    )
  );
}