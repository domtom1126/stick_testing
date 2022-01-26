import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListingView {
  final cars = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date_added', descending: true)
      .snapshots();
  Widget getListings() {
    return StreamBuilder(
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
    );
  }
}
