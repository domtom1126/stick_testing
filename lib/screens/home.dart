import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/main.dart';
import 'package:find_a_stick/screens/view_car.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// TODO Add explain page for first time runners
// TODO * Add package is_first_run

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool onLiked = false;
  final cars = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date_added', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home'),
          centerTitle: false,
          bottom: PreferredSize(
            child: Container(
              color: HexColor('EE6C4D'),
              height: 1,
            ),
            preferredSize: const Size.fromHeight(1),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ]),
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
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () => {
                    showCarModal(context, publicList),
                  },
                  child: CachedNetworkImage(
                    imageUrl: publicList['image'],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )),
          ),
          // const SizedBox(
          //   height: 10,
          // ),

          Row(
            children: [
              Text(
                '${publicList['year']} ${publicList['make']} ${publicList['model']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (FirebaseAuth.instance.currentUser?.uid == null) Container()
              // TODO add like button to let user know if theyve liked current car
              // else
              //   IconButton(
              //     icon: Icon(Icons.favorite, color: Colors.red),
              //     onPressed: () {
              //       // FirebaseFirestore.instance
              //       //     .collection('posts')
              //       //     .doc(widget.docId)
              //       //     .update({
              //       //   'likedIds': FieldValue.arrayRemove([uid])
              //       // });
              //       // setState(() {
              //       //   onLiked = false;
              //       // });
              //     },
              //   )
            ],
          ),
          Text(
            '${publicList['price']}',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
      subtitle: Text(
        '${publicList['odometer']} Miles',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Future<dynamic> showCarModal(
      BuildContext context, QueryDocumentSnapshot<Object?> publicList) {
    return showModalBottomSheet(
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
        publicList.id,
      ),
    );
  }
}
