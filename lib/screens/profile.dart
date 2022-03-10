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
      body: Obx(() {
        if (controller.googleAccount.value == null) {
          return buildSignIn(context);
        } else {
          return buildProfilePage(context);
        }
      }),
    );
  }

  Center buildSignIn(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: 400,
        width: 300,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  child: Text('Sign in with Google')),
            ),
          ],
        ),
      ),
    );
  }

  Center buildProfilePage(BuildContext context) {
    return Center(
      child: Container(
        height: 400,
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            backgroundImage:
                NetworkImage(controller.googleAccount.value?.photoUrl ?? ''),
            radius: 50,
          ),
          SizedBox(
            height: 40,
          ),
          Text(controller.googleAccount.value?.displayName ?? '',
              style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          Text(controller.googleAccount.value?.email ?? '',
              style: TextStyle(fontSize: 20)),
          SizedBox(
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
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  controller.logout();
                },
                child: const Text('Sign Out')),
          ),
        ]),
      ),
    );
  }
}
