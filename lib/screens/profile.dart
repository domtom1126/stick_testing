import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
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
      appBar: appBar(context, 'Profile'),
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

  Widget buildProfilePage(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL ?? ''),
            radius: 75,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(user.displayName ?? '',
              style: TextStyle(fontSize: 20, color: HexColor('FFFFFF'))),
          const SizedBox(
            height: 10,
          ),
          Text(user.email ?? 'No email found',
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
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () => showModalBottomSheet(
                      backgroundColor: HexColor('40434E'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: showUserCars),
                  child: const Text('Your Cars')),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
              height: 25,
            ),
            Text(
              'You\'re not logged in!',
              style: TextStyle(color: HexColor('FFFFFF'), fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sign in below with Google. \n You\'ll see your profile after you sign in.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              height: 50,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SignInButton(Buttons.Google,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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

  ListView showUserCars(BuildContext context) {
    final userCars = FirebaseFirestore.instance
        .collection('posts')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return ListView(
      children: [
        Column(children: [
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: userCars,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.docs.map((userCars) {
                    return ListTile(
                      title: Text(
                        '${userCars['year']} ${userCars['make']} ${userCars['model']}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: const TextButton(
                          // TODO add mark as sold button
                          onPressed: null,
                          child: Text('Mark as Sold')),
                      // Delete post button
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('posts')
                              .doc(userCars.id)
                              .delete();
                        },
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Text('You haven\'t posted any cars yet!');
              }
            },
          )
        ])
      ],
    );
  }
}
