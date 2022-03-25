import 'package:find_a_stick/signin_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return buildProfilePage(context);
            } else {
              return buildSignIn(context);
            }
          }),
    );
  }

  Center buildProfilePage(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Center(
      child: Container(
        height: 450,
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL!),
            radius: 50,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(user.displayName!,
              style: TextStyle(fontSize: 20, color: HexColor('FFFFFF'))),
          const SizedBox(
            height: 10,
          ),
          Text(user.email!,
              style: TextStyle(fontSize: 20, color: HexColor('FFFFFF'))),
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  null;
                },
                child: const Text('Edit Profile')),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: ElevatedButton(
          //       onPressed: () => showModalBottomSheet(
          //           backgroundColor: HexColor('40434E'),
          //           shape: const RoundedRectangleBorder(
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(20),
          //               topRight: Radius.circular(20),
          //             ),
          //           ),
          //           context: context,
          //           builder: showUserCars),
          //       child: const Text('Your Cars')),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogout();
                },
                child: const Text('Sign Out')),
          ),
        ]),
      ),
    );
  }

  Center buildSignIn(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        height: 400,
        width: 300,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'You\'re not logged in!',
              style: TextStyle(color: HexColor('FFFFFF'), fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sign in below with Google. You\'ll see your profile after you sign in.',
                style: TextStyle(color: HexColor('FFFFFF'), fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: SignInButton(Buttons.Google,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              }),
            ),
            SizedBox(
              width: 200,
              child: SignInButton(Buttons.Apple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), onPressed: () {
                final appleProvider =
                    Provider.of<AppleSignInProvider>(context, listen: false);
                appleProvider.appleLogin();
              }, text: 'Sign in with Apple'),
            ),
          ],
        ),
      ),
    );
  }
}
