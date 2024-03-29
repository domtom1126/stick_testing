import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/edit_user_car.dart';
import 'package:find_a_stick/screens/messages_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

File? pickedImage;
final user = FirebaseAuth.instance.currentUser!;
Future pickImage() async {
  final _imagePicker = ImagePicker();
  final userPickedImage =
      await _imagePicker.pickImage(source: ImageSource.gallery);
  pickedImage = File(userPickedImage!.path);

  // * Trying to get the profile pic to show
}

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
    bool isSold;

    final userCars = FirebaseFirestore.instance
        .collection('posts')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL ?? ''),
                  radius: 60,
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.add_a_photo),
                      color: HexColor('DF7212'),
                      onPressed: () {
                        // TODO Firebase needs to update once the photo is picked
                        pickImage();
                      },
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: HexColor('2B303A'),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            50,
                          ),
                        ),
                        color: HexColor('2B303A'),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(2, 4),
                            color: Colors.black.withOpacity(
                              0.2,
                            ),
                            blurRadius: 1,
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   width: 50,
            // ),
            Column(
              children: [
                Row(
                  children: [
                    const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.light_mode_outlined,
                          color: Colors.white,
                        )),
                    Text(user.displayName ?? '',
                        style:
                            TextStyle(fontSize: 18, color: HexColor('FFFFFF'))),
                  ],
                ),
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
                  height: 45,
                  width: 200,
                  child: ElevatedButton(
                      child: const Text('Enter Zip Code'),
                      onPressed: () {
                        enterZipCodeDialog(context);
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 45,
                  width: 200,
                  child: ElevatedButton(
                    child: const Text('Messages'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Messages())));
                    },
                  ),
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        const Center(
          child: Text(
            'Your Cars',
            style: TextStyle(fontSize: 24),
          ),
        ),
        const Center(
          child: Text(
            'Click to edit listing',
            style: TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        // TODO You have not posted any cars yet works but it disappears
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: HexColor('41454E')),
          height: 250,
          width: 400,
          child: StreamBuilder(
            stream: userCars,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              images: userCars['images'],
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
                      subtitle: Row(
                        children: [
                          if (userCars['sold'] == true)
                            TextButton(
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
                          else
                            TextButton(
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
                                  'Mark as sold',
                                  style: TextStyle(color: HexColor('FFFFFF')),
                                  textAlign: TextAlign.left,
                                )),
                        ],
                      ),
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
        // privacy policy button
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                child: const Text('Privacy Policy'),
                onPressed: () {
                  // show dialog
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                            backgroundColor: Colors.black45,
                            title: Text('Privacy Policy'),
                            content: Text('hello'));
                      });
                }),
          ),
        ),
      ]),
    );
  }

  Future<dynamic> enterZipCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Zip Code'),
            backgroundColor: HexColor('23262F'),
            content: Column(
              // * This controls the height so it doesnt fill the whole screen(for reference)
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Your zip code IS NOT required to view or post a car but it helps to find cars near you.'),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _zipcodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    fillColor: Colors.white30,
                    label: Text('Zip Code'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: const ButtonStyle(
                        // backgroundColor: MaterialStateProperty.all(EE6C4F),
                        ),
                    onPressed: () {},
                    child: const Text('Save')),
              ],
            ),
          );
        });
  }
}
