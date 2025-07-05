import 'package:flutter/material.dart';
import 'package:krishco/utilities/custom_theme/text_theme/text_theme.dart';

class TDropdownButtonTheme{
  TDropdownButtonTheme._();
  static final DropdownMenuThemeData light = DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0)
        )
      ),
    menuStyle: MenuStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))
      )
    ),
    textStyle: TTextTheme.lightTextTheme.bodyMedium
      );

  static final DropdownMenuThemeData dark = DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0)
          )
      ),
      menuStyle: MenuStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))
          )
      ),
      textStyle: TTextTheme.darkTextTheme.bodyMedium
  );
}