import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:testing/screens/post.dart';
import 'package:testing/screens/profile.dart';
import 'package:testing/widgets/bottom_bar.dart';

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
  final buttonForegroundColor = HexColor('FFC107');
  final buttonBorderColor = HexColor('EE6C4D');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: bottomBarBackgroundColor,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
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
        // Global appBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: appBarBackgroundColor,
          foregroundColor: appBarTextColor,
          elevation: 0,
        ),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      ),
      home: const BottomBar(),
    );
  }
}
