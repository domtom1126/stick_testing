import 'package:find_a_stick/screens/intro.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:find_a_stick/widgets/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("3880da7a-2f7c-4c2f-9a08-ade57d9ccb0f");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  final bool showHome;
  const MyApp({Key? key, required this.showHome}) : super(key: key);

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
            theme: darkTheme(),
            darkTheme: darkTheme(),
            themeMode: currentMode,
            home: showHome ? const BottomBar() : const IntroductionScreen(),
          ),
        );
      },
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
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
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: HexColor('FFFFFF'),
        elevation: 0,
      ),
      // * Scaffold Theme
      // scaffoldBackgroundColor: HexColor('7E8987'),
      scaffoldBackgroundColor: HexColor('2B303A'),
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
            color: HexColor('FFFFFF'),
            fontWeight: FontWeight.w300,
            fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        isCollapsed: true,
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
      // * AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor('FFFFFF'),
        foregroundColor: HexColor('FFFFFF'),
        elevation: 0,
      ),
      // * Scaffold Theme
      scaffoldBackgroundColor: HexColor('2B303A'),
      // scaffoldBackgroundColor: HexColor('F5F8F2'),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            fontSize: 20,
            color: HexColor('FFFFFF'),
            fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(
            fontSize: 18,
            color: HexColor('000000'),
            fontWeight: FontWeight.w300),
        bodySmall: TextStyle(
          fontSize: 13,
          color: HexColor('000000'),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          color: HexColor('000000'),
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          color: HexColor('000000'),
          fontWeight: FontWeight.bold,
        ),
      ),
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
        selectedItemColor: HexColor('EE6C4D'),
        unselectedItemColor: HexColor('EE6C4D'),
      ),
      // * END bottom bar theme
    );
  }
}
