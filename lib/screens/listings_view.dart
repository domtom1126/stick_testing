import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../listing.dart';
import '../listing_cubit.dart';

class ListingsView extends StatelessWidget {
  ListingsView({Key? key}) : super(key: key);
  final cars = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date_added', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Stick'),
      ),
      body: StreamBuilder(
        stream: cars,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data!.docs.map((publicList) {
              return ListTile(
                title: Text('${publicList['make']}'),
                subtitle: Text('${publicList['model']}'),
                onTap: () {},
              );
            }).toList());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
