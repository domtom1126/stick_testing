import 'package:find_a_stick/screens/home.dart';
import 'package:find_a_stick/screens/liked.dart';
import 'package:find_a_stick/screens/post.dart';
import 'package:find_a_stick/screens/profile.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:find_a_stick/widgets/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final appBarBackgroundColor = Colors.transparent;
  final appBarTextColor = HexColor('ffffff');
  final scaffoldBackgroundColor = HexColor('37383B');
  final bottomBarBackgroundColor = HexColor('5A676B');
  final selectedColor = HexColor('FFFFFF');
  final unselectedColor = HexColor('353738');
  final buttonBackgroundColor = HexColor('59797D');
  final buttonForegroundColor = HexColor('ffffff');
  final buttonBorderColor = HexColor('F25922');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO Use multiprovider here
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => AppleSignInProvider()),
      ],
      child: MaterialApp(
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => const BottomBar(),
          );
        },
        // initialRoute: '/',
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
              minimumSize: MaterialStateProperty.all<Size>(const Size(100, 40)),
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
                    width: 2,
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
      ),
    );
  }
}
