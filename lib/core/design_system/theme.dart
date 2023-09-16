import 'package:flutter/material.dart';
import 'package:klsha/core/constant.dart';
import 'package:klsha/core/design_system/color.dart';
import 'package:klsha/core/design_system/typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        fontFamily: AppConstant.primaryTypeface,
        scaffoldBackgroundColor: AppColor.gray100,
        appBarTheme: const AppBarTheme(
          color: AppColor.black,
          elevation: 0.0,
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: AppTypography.body1.copyWith(
            fontFamily: AppConstant.primaryTypeface,
          ),
        ),
      );
}
