import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:testing/firebase_functions/get_listings.dart';
import 'package:testing/screens/view_car.dart';

import '../listing.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: HexColor('5A676B'),
            pinned: false,
            snap: false,
            floating: true,
            title: Text('Home'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return StreamBuilder(
                  stream: cars,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data!.docs.map((publicList) {
                        return buildCar(publicList, context);
                      }).toList());
                    } else {
                      return const Center(child: Text('no Data'));
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ListTile buildCar(
      QueryDocumentSnapshot<Object?> publicList, BuildContext context) {
    return ListTile(
      // TODO maybe add some "leading:" text?
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            publicList['image'],
            height: 200,
            width: 200,
          ),
          Text(
            '${publicList['price']}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '${publicList['year']} ${publicList['make']} ${publicList['model']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      subtitle: Text('${publicList['odometer']} Miles'),
      onTap: () {
        showModalBottomSheet(
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
            publicList['image'],
            publicList['description'],
          ),
        );
      },
    );
  }
}
