import 'package:find_a_stick/screens/liked_screens/liked_screen.dart';
import 'package:find_a_stick/screens/liked_screens/liked_signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// User? firebaseUser = FirebaseAuth.instance.currentUser;
// Widget? likedScreen;

// if(firebaseUser != null) {
//   likedScreen = LikedScreen(p)
// }

class Liked extends StatefulWidget {
  const Liked({Key? key}) : super(key: key);

  @override
  _LikedState createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    backgroundColor: Colors.transparent,
                    floating: true,
                    pinned: false,
                    snap: false,
                    title: Text(
                      'Liked Cars',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
            body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  // * Liked screen
                  return const LikedScreen();
                } else {
                  // * Sign in screen
                  return LikedSignIn();
                }
              },
            )));
  }
}
