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
                    builder: (context) => viewCar(
                        publicList['make'],
                        publicList['model'],
                        publicList['year'],
                        publicList['price'],
                        publicList['odometer']));
              },
            );
          }).toList());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Widget viewCar(make, model, year, price, odometer) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$year $make $model'),
        Text('$price'),
        Text('$odometer Miles'),
        // Text('${publicList['description']}'),
      ],
    ),
  );
}
