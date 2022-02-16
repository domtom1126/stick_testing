import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing/firebase_functions/get_listings.dart';
import 'package:testing/screens/view_car.dart';

import '../listing.dart';
import '../listing_bloc.dart';

// TODO this page will get the most recent listings. Wrap with BlocBuilder
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final cars = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date_added', descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: StreamBuilder(
        stream: cars,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data!.docs.map((publicList) {
              return ListTile(
                // TODO maybe add some "leading:" text?
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Placeholder(
                      fallbackHeight: 250,
                    ),
                    Text(
                      '${publicList['price']}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${publicList['year']} ${publicList['make']} ${publicList['model']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Text('${publicList['odometer']} Miles'),
                onTap: () {
                  showBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => ViewCar(
                      publicList['make'],
                      publicList['model'],
                      publicList['year'],
                      publicList['price'],
                      publicList['odometer'],
                      publicList['description'],
                    ),
                  );
                },
              );
            }).toList());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
