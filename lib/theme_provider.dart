import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isDarkMode) {
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
      ),
      // * Circular Progress Indicator Color
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: HexColor('DF7212'),
        primary: HexColor('DF7212'),
      ),
      // * AppBar Theme
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // * Scaffold Theme(Main background color)
      // scaffoldBackgroundColor: HexColor('7E8987'),
      scaffoldBackgroundColor: HexColor('2B303A'),
      // * Theme of text
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            fontSize: 25,
            color: HexColor('FFFFFF'),
            fontWeight: FontWeight.w300),
        bodyMedium: TextStyle(
          fontSize: 18,
          color: HexColor('FFFFFF'),
          fontWeight: FontWeight.w300,
        ),
        bodySmall: TextStyle(
          fontSize: 15,
          color: HexColor('FFFFFF'),
          fontWeight: FontWeight.w300,
        ),
        titleLarge: TextStyle(
          fontSize: 26,
          color: HexColor('FFFFFF'),
          fontWeight: FontWeight.w300,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          color: HexColor('FFFFFF'),
          fontWeight: FontWeight.w300,
        ),
      ),
      // * START button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          minimumSize: MaterialStateProperty.all<Size>(const Size(500, 40)),
          backgroundColor: MaterialStateProperty.all<Color>(
              // HexColor('EE6C4D'),
              // * Try it out
              HexColor('DF7212')),
          foregroundColor: MaterialStateProperty.all<Color>(
            HexColor('ffffff'),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
      // * END button theme
      // * START text form field theme
      inputDecorationTheme: InputDecorationTheme(
        labelStyle:
            TextStyle(color: HexColor('FFFFFF'), fontWeight: FontWeight.w300),
        hintStyle: TextStyle(
            color: HexColor('000000'),
            fontWeight: FontWeight.w300,
            fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        isCollapsed: false,
        filled: true,
      ),
      // * END text form field theme
      // * START bottom bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: HexColor('2D2D30'),
        selectedItemColor: HexColor('DDDDDD'),
        unselectedItemColor: Colors.grey[400],
      ),
      // * END bottom bar theme
    );
  }

  ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
      ),
      // * Circular Progress Indicator Color
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: HexColor('FFFFFF'),
        primary: HexColor('FFFFFF'),
      ),
      // * AppBar Theme
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        foregroundColor: HexColor('000000'),
        elevation: 0,
      ),
      // * Scaffold Theme(Main background color)
      // scaffoldBackgroundColor: HexColor('7E8987'),
      scaffoldBackgroundColor: HexColor('FFFFFF'),
      // * Theme of text
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            fontSize: 25,
            color: HexColor('000000'),
            fontWeight: FontWeight.w300),
        bodyMedium: TextStyle(
          fontSize: 18,
          color: HexColor('000000'),
          fontWeight: FontWeight.w300,
        ),
        bodySmall: TextStyle(
          fontSize: 15,
          color: HexColor('000000'),
          fontWeight: FontWeight.w300,
        ),
        titleLarge: TextStyle(
          fontSize: 26,
          color: HexColor('000000'),
          fontWeight: FontWeight.w300,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          color: HexColor('000000'),
          fontWeight: FontWeight.w300,
        ),
      ),
      // * START button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          minimumSize: MaterialStateProperty.all<Size>(const Size(500, 40)),
          backgroundColor: MaterialStateProperty.all<Color>(
              // HexColor('EE6C4D'),
              // * Try it out
              HexColor('DF7212')),
          foregroundColor: MaterialStateProperty.all<Color>(
            HexColor('666769'),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
      // * END button theme
      // * START text form field theme
      inputDecorationTheme: InputDecorationTheme(
        labelStyle:
            TextStyle(color: HexColor('000000'), fontWeight: FontWeight.w300),
        hintStyle: TextStyle(
            color: HexColor('000000'),
            fontWeight: FontWeight.w300,
            fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        // isCollapsed: false,
        // filled: true,
      ),
      // * END text form field theme
      // * START bottom bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: HexColor('2D2D30'),
        selectedItemColor: HexColor('EF8354'),
        unselectedItemColor: Colors.black,
      ),
      // * END bottom bar theme
    );
  }
}
