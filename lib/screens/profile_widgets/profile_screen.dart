import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/edit_user_car.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

TextEditingController _zipcodeController = TextEditingController();

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return buildProfilePage(context);
  }

  Widget buildProfilePage(BuildContext context) {
    bool isSold = false;
    final userCars = FirebaseFirestore.instance
        .collection('posts')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
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
                // * Button to enter zipcode
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      child: const Text('Enter Zip Code'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Enter Zip Code'),
                                backgroundColor: HexColor('7C90A0'),
                                content: Column(
                                  // * This controls the height so it doesnt fill the whole screen(for reference)
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        'Your zip code IS NOT required to view or post a car but it helps to find cars near you.)'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _zipcodeController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Zip Code',
                                      ),
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                        ),
                                        onPressed: () {},
                                        child: const Text('Save')),
                                  ],
                                ),
                              );
                            });
                      }),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child:
              Text('Your cars', style: Theme.of(context).textTheme.headline6),
        ),
        const Center(child: Text('Click to edit details')),
        const SizedBox(
          height: 20,
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            color: HexColor('23262F'),
            child: StreamBuilder(
              stream: userCars,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'You have not posted any cars yet.',
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
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
                        subtitle: (isSold)
                            ? TextButton(
                                // TODO add mark as sold button
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(userCars.id)
                                      .update({
                                    'sold': false,
                                  });
                                  setState(() {
                                    isSold = false;
                                  });
                                },
                                child: Text(
                                  'Mark as not sold',
                                  style: TextStyle(color: HexColor('FFFFFF')),
                                  textAlign: TextAlign.left,
                                ))
                            : TextButton(
                                // TODO add mark as sold button
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(userCars.id)
                                      .update({
                                    'sold': true,
                                  });
                                  setState(() {
                                    isSold = true;
                                  });
                                },
                                child: Text(
                                  'Mark as Sold',
                                  style: TextStyle(color: HexColor('FFFFFF')),
                                  textAlign: TextAlign.left,
                                )),
                        // Delete post button
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: HexColor('EE6C4F')),
                          onPressed: () async {
                            await HapticFeedback.heavyImpact();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black45,
                                    title: const Text('Are you sure?'),
                                    content: Text(
                                        'Do you want to delete this car?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    actions: [
                                      ElevatedButton(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(userCars.id)
                                              .delete();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text('No'),
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
                  return const Text('Loading...');
                }
              },
            ),
          ),
        ),
      ]),
    );
  }
  // TODO This might return null
  // Alert dialog
  // StatelessWidget enterZipCode() {
  // showDialog(
  // context: context,
  // builder: (BuildContext context) {
  // return AlertDialog(
  // title: const Text('Are you sure?'),
  // content: Text('Do you want to delete this car?',
  // style: Theme.of(context).textTheme.bodyMedium),
  // actions: [
  // ElevatedButton(
  // child: const Text('Yes'),
  // onPressed: () {
  // Navigator.of(context).pop();
  // },
  // ),
  // ElevatedButton(
  // child: const Text('No'),
  // onPressed: () {
  // Navigator.of(context).pop();
  // },
  // )
  // ],
  // );
  // },
  // );
  // }
}
