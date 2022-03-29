import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/view_car.dart';
import 'package:find_a_stick/widgets/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// TODO this page will get the most recent listings. Wrap with BlocBuilder

bool onLiked = false;

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Home'),
        leading: IconButton(icon: Icon(Icons.search), onPressed: () {}),
      ),
      body: StreamBuilder(
        stream: cars,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data!.docs.map((publicList) {
              return buildCar(publicList, context);
            }).toList());
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: HexColor('4C6273'),
              ),
            );
          }
        },
      ),
    );
  }

  ListTile buildCar(
      QueryDocumentSnapshot<Object?> publicList, BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () => {
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
                        publicList['make'],
                        publicList['model'],
                        publicList['year'],
                        publicList['price'],
                        publicList['odometer'],
                        publicList['image'],
                        publicList['description'],
                        publicList['email'],
                      ),
                    ),
                  },
                  child: Image.network(
                    publicList['image'],
                    fit: BoxFit.fitWidth,
                  ),
                )),
          ),
          // const SizedBox(
          //   height: 10,
          // ),

          Text(
            '${publicList['year']} ${publicList['make']} ${publicList['model']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HexColor('FFFFFF'),
            ),
          ),
          Text(
            '${publicList['price']}',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HexColor('FFFFFF')),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
      subtitle: Text(
        '${publicList['odometer']} Miles',
        style: TextStyle(
          fontSize: 13,
          color: HexColor('FFFFFF'),
        ),
      ),
      onTap: () {
        // showModalBottomSheet(
        //   isScrollControlled: true,
        //   backgroundColor: HexColor('40434E'),
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //     ),
        //   ),
        //   context: context,
        //   builder: (context) => ViewCar(
        //     publicList['make'],
        //     publicList['model'],
        //     publicList['year'],
        //     publicList['price'],
        //     publicList['odometer'],
        //     publicList['image'],
        //     publicList['description'],
        //     publicList['email'],
        //   ),
        // );
      },
    );
  }
}
