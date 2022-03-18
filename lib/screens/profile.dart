import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../signin_controller.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
              child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  child: const Text('Sign in with Google')),
            ),
          ],
        ),
      ),
    );
  }

  Center buildProfilePage(BuildContext context) {
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
            backgroundImage:
                NetworkImage(controller.googleAccount.value?.photoUrl ?? ''),
            radius: 50,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(controller.googleAccount.value?.displayName ?? '',
              style: TextStyle(fontSize: 20, color: HexColor('FFFFFF'))),
          const SizedBox(
            height: 10,
          ),
          Text(controller.googleAccount.value?.email ?? '',
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
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () => showModalBottomSheet(
                    context: context, builder: showUserCars),
                child: const Text('Your Cars')),
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

  SafeArea showUserCars(BuildContext context) {
    final userCars = FirebaseFirestore.instance
        .collection('posts')
        .where('email', isEqualTo: controller.googleAccount.value?.email)
        .snapshots();
    return SafeArea(
      child: Column(children: [
        const Text('Your Cars'),
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
                    title: Text(userCars['Make']),
                    subtitle: Text(userCars['Model']),
                    // Delete post button
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
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
      ]),
    );
  }
}
