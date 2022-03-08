import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testing/screens/create_account.dart';
import 'package:testing/screens/sign_in.dart';

import '../signin_controller.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  login() {
    try {
      googleSignIn.signIn();
    } catch (e) {
      print(e);
    }
  }

  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.googleAccount.value == null) {
            return buildSignIn(context);
          } else {
            return buildProfilePage(context);
          }
        }),
      ),
    );
  }

  Column buildSignIn(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              controller.login();
            },
            child: Text('Sign in with Google')),
      ],
    );
  }

  Column buildProfilePage(BuildContext context) {
    return Column(children: [
      Text(controller.googleAccount.value?.displayName ?? '',
          style: TextStyle(fontSize: 20)),
      Text(controller.googleAccount.value?.email ?? '',
          style: TextStyle(fontSize: 20)),
      ElevatedButton(
          onPressed: () {
            null;
          },
          child: const Text('Sign Out')),
    ]);
  }
}
