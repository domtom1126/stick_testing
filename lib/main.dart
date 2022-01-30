import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:testing/screens/post.dart';
import 'package:testing/screens/profile.dart';
import 'package:testing/widgets/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              HexColor('#FFC107'),
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              HexColor('#FFC107'),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: HexColor('EE6C4D'),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        // Global appBar theme
        appBarTheme: AppBarTheme(
          color: HexColor('5890B8'),
          elevation: 0,
        ),
        scaffoldBackgroundColor: HexColor('91BCDB'),
      ),
      home: const BottomBar(),
    );
  }
}
