import 'package:flutter/material.dart';

import 'app_color_constant.dart';

class AppTheme {
  AppTheme._();

  static getApplicationTheme() {
    return ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColorConstant.primaryColor,
        ),
        fontFamily: 'sf-medium',
        useMaterial3: true,
        appBarTheme: getAppBarTheme(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            // backgroundColor: AppColorConstant.primaryColor,
            // selectedItemColor: AppColorConstant.white,
            // unselectedItemColor: AppColorConstant.black,
            // type: BottomNavigationBarType.fixed,

            // elevation: 0,
            ));
  }

  static getAppBarTheme() {
    return const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColorConstant.black,
        fontSize: 20,
      ),
    );
  }
}
