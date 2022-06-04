import 'package:find_a_stick/screens/profile_widgets/profile_screen.dart';
import 'package:find_a_stick/screens/profile_widgets/sign_in.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isSold = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          AppBar(title: const Text('Profile'), centerTitle: false, actions: [
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: HexColor('EE6C4D'),
          ),
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleLogout();
          },
        ),
      ]),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return const ProfilePage();
            } else {
              return const ProfileSignIn();
            }
          }),
    );
  }

  // StreamBuilder showUserCars() {
  //   return
  // }
}
