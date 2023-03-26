

import 'package:flutter/material.dart';
import 'constant.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: scaffoldBackGroundColorLight,
      // appBarTheme: appBarTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: kPrimaryColor,
        titleTextStyle: TextStyle(color: kPrimaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
      ),
      textTheme:const TextTheme(
        headline1: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(color:Colors.black, fontSize: 16),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: scaffoldBackGroundColorDark,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackGroundColorDark,
        titleTextStyle: TextStyle(color: kPrimaryColor),
        iconTheme: IconThemeData(color: kPrimaryColor),
        elevation: 0,
      ),
      textTheme:const TextTheme(
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldBackGroundColorDark,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: kPrimaryColor),
        showUnselectedLabels: true,
      ),
    );
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}

final appBarTheme = AppBarTheme(
    centerTitle: false, elevation: 0, backgroundColor: Colors.white);
