import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:testing/screens/post.dart';
import 'package:testing/screens/profile.dart';
import 'package:testing/widgets/bottom_bar.dart';

import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final appBarBackgroundColor = Colors.transparent;
  final appBarTextColor = HexColor('ffffff');
  final scaffoldBackgroundColor = HexColor('6E6D73');
  final bottomBarBackgroundColor = HexColor('AFBDC7');
  final selectedColor = HexColor('C95132');
  final unselectedColor = HexColor('666666');
  final buttonBackgroundColor = HexColor('857572');
  final buttonForegroundColor = HexColor('ffffff');
  final buttonBorderColor = HexColor('EE6C4D');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => BottomBar(),
        );
      },
      // initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // * AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: appBarBackgroundColor,
          foregroundColor: appBarTextColor,
          elevation: 0,
        ),
        // * Scaffold Theme
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        // * START button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
            backgroundColor: MaterialStateProperty.all<Color>(
              buttonBackgroundColor,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              buttonForegroundColor,
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: buttonBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        // * END button theme
        // * START text form field theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: buttonBorderColor,
              width: 1,
            ),
          ),
          isCollapsed: true,
          // filled: true,
        ),
        // * END text form field theme
        // * START bottom bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: bottomBarBackgroundColor,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
        ),
        // * END bottom bar theme
      ),
      home: const BottomBar(),
    );
  }
}
