import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/view_car.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Liked extends StatefulWidget {
  const Liked({Key? key}) : super(key: key);

  @override
  _LikedState createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, 'Liked'),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return userLikedCars();
              } else {
                return buildSignIn(context);
              }
            }));
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> userLikedCars() {
    final cars = FirebaseFirestore.instance
        .collection('posts')
        .where('likedIds',
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder(
      stream: cars,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView(
              children: snapshot.data!.docs.map((userLikedCars) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: HexColor('40434E'),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) => ViewCar(
                          userLikedCars['make'],
                          userLikedCars['model'],
                          userLikedCars['year'],
                          userLikedCars['price'],
                          userLikedCars['odometer'],
                          userLikedCars['image'],
                          userLikedCars['description'],
                          userLikedCars['email'],
                          userLikedCars.id,
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: userLikedCars['image'],
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  Text(
                    '${userLikedCars['year']} ${userLikedCars['make']} ${userLikedCars['model']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${userLikedCars['price']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              subtitle: Text(
                '${userLikedCars['odometer']} Miles',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }).toList());
        } else {
          return const Center(
            child: Text('You haven\'t liked any cars yet'),
          );
        }
      },
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
                'Sign in below with Google. \n You\'ll see your liked cars after you sign in.',
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
}
