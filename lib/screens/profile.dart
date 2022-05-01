import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/edit_user_car.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              return buildProfilePage(context);
            } else {
              return buildSignIn(context);
            }
          }),
    );
  }

  Widget buildProfilePage(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ''),
              radius: 60,
            ),
            // const SizedBox(
            //   width: 50,
            // ),
            Column(
              children: [
                // TODO make edit button work
                // editButton(),
                const SizedBox(
                  height: 10,
                ),
                Text(user.displayName ?? '',
                    style: TextStyle(fontSize: 18, color: HexColor('FFFFFF'))),
                const SizedBox(
                  height: 10,
                ),
                Text(user.email ?? 'No email found',
                    style: TextStyle(fontSize: 18, color: HexColor('FFFFFF'))),
                const SizedBox(
                  height: 30,
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child:
              Text('Your cars', style: Theme.of(context).textTheme.headline6),
        ),
        const SizedBox(
          height: 20,
        ),
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                color: HexColor('23262F'),
                child: showUserCars(context))),
      ]),
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
                'Sign in below and you will see your profile after you sign in.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(
              height: 50,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: HexColor('FFFFFF')),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor('FFFFFF')),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor('FFFFFF')),
                ),
              ),
              style: TextStyle(color: HexColor('FFFFFF')),
              keyboardType: TextInputType.emailAddress,
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
      shrinkWrap: true,
      // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      children: [
        Column(children: [
          StreamBuilder(
            stream: userCars,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.docs.map((userCars) {
                    return ListTile(
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserCar(
                              make: userCars['make'],
                              model: userCars['model'],
                              year: userCars['year'],
                              price: userCars['price'],
                              odometer: userCars['odometer'],
                              image: userCars['image'],
                              description: userCars['description'],
                              id: userCars.id,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        '${userCars['year']} ${userCars['make']} ${userCars['model']}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: TextButton(
                          // TODO add mark as sold button
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('posts')
                                .doc(userCars.id)
                                .update({
                              'sold': true,
                            });
                          },
                          child: Text(
                            'Mark as Sold',
                            style: TextStyle(color: HexColor('FFFFFF')),
                            textAlign: TextAlign.left,
                          )),
                      // Delete post button
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () async {
                          await HapticFeedback.heavyImpact();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black45,
                                  title: Text('Are you sure?'),
                                  content: Text(
                                      'Do you want to remove this car from your likes?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  actions: [
                                    ElevatedButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(userCars.id)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
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
