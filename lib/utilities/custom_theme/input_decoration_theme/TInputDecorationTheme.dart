import 'package:flutter/material.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/utilities/custom_theme/text_theme/text_theme.dart';

class TInputDecorationTheme{
  TInputDecorationTheme._();

  static InputDecorationTheme light =  InputDecorationTheme(
    labelStyle: TTextTheme.lightTextTheme.bodySmall!.copyWith(
      color: Colors.black54,
    ),
    filled: true,
    fillColor:  Colors.grey[100],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    hintStyle: TTextTheme.lightTextTheme.bodySmall!.copyWith(color: Colors.grey.shade600,overflow: TextOverflow.ellipsis),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color:  Colors.grey[300]!,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color:  Colors.grey[300]!,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color:  Colors.grey[300]!,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  );


  static InputDecorationTheme dark = InputDecorationTheme(
    labelStyle: TTextTheme.darkTextTheme.bodySmall!.copyWith(
      color:  Colors.white70,
    ),
    filled: true,
    fillColor: Colors.grey[850],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    hintStyle: TTextTheme.lightTextTheme.bodySmall!.copyWith(color: Colors.grey.shade600,overflow: TextOverflow.ellipsis),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.purple,
            width: 1.2
        )),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[700]!,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color:  Colors.grey[300]!,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}