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
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO Use multiprovider here
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
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
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: currentMode,
            home: const BottomBar(),
          ),
        );
      },
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      // * AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: HexColor('ffffff'),
        elevation: 0,
      ),
      // * Scaffold Theme
      scaffoldBackgroundColor: HexColor('2D2D30'),
      textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontSize: 20,
              color: HexColor('FFFFFF'),
              fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(
              fontSize: 18,
              color: HexColor('FFFFFF'),
              fontWeight: FontWeight.bold),
          bodySmall: TextStyle(
              fontSize: 13,
              color: HexColor('ffffff'),
              fontWeight: FontWeight.bold)),
      // * START button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(100, 40)),
          backgroundColor: MaterialStateProperty.all<Color>(
            HexColor('59797D'),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            HexColor('ffffff'),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                color: HexColor('F25922'),
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
        hintStyle: TextStyle(color: HexColor('FFFFFF')),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: HexColor('F25922'),
            width: 1,
          ),
        ),
        isCollapsed: true,
        // filled: true,
      ),
      // * END text form field theme
      // * START bottom bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: HexColor('2D2D30'),
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.grey[400],
      ),
      // * END bottom bar theme
    );
  }

  ThemeData lightTheme() {
    return ThemeData(
      // * AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor('2D2D30'),
        foregroundColor: HexColor('FFFFFF'),
        elevation: 0,
      ),
      textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontSize: 20,
              color: HexColor('000000'),
              fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(
              fontSize: 18,
              color: HexColor('000000'),
              fontWeight: FontWeight.bold),
          bodySmall: TextStyle(
              fontSize: 13,
              color: HexColor('000000'),
              fontWeight: FontWeight.bold)),
      // * Scaffold Theme
      scaffoldBackgroundColor: HexColor('F3F3F3'),
      // * START button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(100, 40)),
          backgroundColor: MaterialStateProperty.all<Color>(
            HexColor('59797D'),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            HexColor('ffffff'),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                color: HexColor('F25922'),
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
        hintStyle: TextStyle(color: HexColor('000000')),
        labelStyle: TextStyle(color: HexColor('000000')),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: HexColor('F25922'),
            width: 1,
          ),
        ),
        isCollapsed: true,
        // filled: true,
      ),
      // * END text form field theme
      // * START bottom bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: HexColor('2D2D30'),
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.grey[400],
      ),
      // * END bottom bar theme
    );
  }
}
