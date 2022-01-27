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
              // leading: Text('hello'),
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
