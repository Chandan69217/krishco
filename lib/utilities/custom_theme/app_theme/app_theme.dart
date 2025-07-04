import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/utilities/custom_theme/appbar_theme/appbar_theme.dart';
import 'package:krishco/utilities/custom_theme/bottom_nav_bar_theme/bottom_navigation_bar_theme.dart';
import 'package:krishco/utilities/custom_theme/dropdown_button_theme/dropdwon_button_theme.dart';
import 'package:krishco/utilities/custom_theme/elevated_btn_theme/elevated_btn_theme.dart';
import 'package:krishco/utilities/custom_theme/icon_btn_theme/icon_btn_theme.dart';
import 'package:krishco/utilities/custom_theme/input_decoration_theme/TInputDecorationTheme.dart';
import 'package:krishco/utilities/custom_theme/list_tile_theme/list_tile_theme.dart';
import 'package:krishco/utilities/custom_theme/popup_menu_theme/popup_menu_theme.dart';
import 'package:krishco/utilities/custom_theme/text_sel_theme_data/text_sel_theme_data.dart';
import 'package:krishco/utilities/custom_theme/text_theme/text_theme.dart';
import 'package:krishco/utilities/custom_theme/txt_btn_theme/txt_btn_theme.dart';



class AppTheme{
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      fontFamily: 'Inter',
      primaryColor: CustColors.primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: TAppbarTheme.lightAppbarTheme,
      bottomNavigationBarTheme: TBottomNavigationBarTheme.light,
      navigationBarTheme: TNavigationBarTheme.light,
      useMaterial3: true,
      textTheme: TTextTheme.lightTextTheme,
    listTileTheme: TListTileTheme.light,
    popupMenuTheme: TPopupMenuTheme.lightTheme,
    checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStatePropertyAll(Colors.white),
      fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return CustColors.nile_blue;
        }
        return Colors.transparent;
      }),
    ),
    elevatedButtonTheme: ElevatedBtnTheme.light,
    dropdownMenuTheme: TDropdownButtonTheme.light,
    textSelectionTheme: TTextSelectionThemeData.light,
    inputDecorationTheme: TInputDecorationTheme.light,
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(CustColors.nile_blue)
    ),
    iconButtonTheme: TIconBtnTheme.light,
      iconTheme: const IconThemeData(
          color: CustColors.white
      ),
      textButtonTheme: TTextButtonTheme.ligth,
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Inter',
    primaryColor: CustColors.primary,
    brightness: Brightness.dark,
    useMaterial3: true,
    navigationBarTheme: TNavigationBarTheme.dart,
    bottomNavigationBarTheme: TBottomNavigationBarTheme.dark,
    dropdownMenuTheme: TDropdownButtonTheme.dark,
    scaffoldBackgroundColor: Colors.black,
      checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStatePropertyAll(Colors.white),
        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return CustColors.nile_blue;
          }
          return Colors.transparent;
        }),
      ),
    appBarTheme: TAppbarTheme.darkAppbarTheme,
      radioTheme: RadioThemeData(
          fillColor: WidgetStatePropertyAll(CustColors.nile_blue),
      ),
    textTheme: TTextTheme.darkTextTheme,
     listTileTheme: TListTileTheme.dark,
    popupMenuTheme: TPopupMenuTheme.darkTheme,
    textSelectionTheme: TTextSelectionThemeData.dark,
    iconButtonTheme: TIconBtnTheme.dark,
    inputDecorationTheme: TInputDecorationTheme.dark,
    elevatedButtonTheme: ElevatedBtnTheme.dark,
    iconTheme: const IconThemeData(
      color: CustColors.white
    ),
    textButtonTheme: TTextButtonTheme.dark
  );

}