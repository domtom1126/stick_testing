import 'package:flutter/material.dart';
import 'package:testing/screens/post.dart';
import 'package:testing/screens/profile.dart';
import 'package:testing/widgets/bottom_bar.dart';

void main() {
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
        // Global appBar theme
        appBarTheme: const AppBarTheme(
          color: Colors.blueGrey,
          elevation: 0,
        ),
        primarySwatch: Colors.blueGrey,
      ),
      home: const BottomBar(),
    );
  }
}
