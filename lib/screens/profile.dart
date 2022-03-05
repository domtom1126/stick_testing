import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/screens/create_account.dart';
import 'package:testing/screens/sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                },
                child: const Text('Sign In')),
            if (auth.currentUser != null)
              ElevatedButton(
                  onPressed: () {
                    auth.signOut();
                  },
                  child: const Text('Sign Out')),
            if (auth.currentUser == null)
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAccount()));
                  },
                  child: const Text('Create an Account')),
            if (auth.currentUser != null)
              Container(
                child: Text('Signed in'),
              ),
            if (auth.currentUser == null)
              Container(
                child: Text('Signed out'),
              ),
          ],
        ),
      ),
    );
  }
}
