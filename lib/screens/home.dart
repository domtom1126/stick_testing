import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/intro.dart';
import 'package:find_a_stick/screens/search.dart';
import 'package:find_a_stick/screens/view_car.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO Add explain page for first time runners
// TODO * Add package is_first_run

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future firstUse() async {
    bool firstRun = await IsFirstRun.isFirstRun();
    if (firstRun) {
      // Open page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const IntroductionScreen(),
        ),
      );
    }
  }

  final cars = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date_added', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    firstUse();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       Icons.search,
              //       color: HexColor('EE6C4D'),
              //     ),
              //     onPressed: () {
              //       showSearch(context: context, delegate: Search());
              //     },
              //   ),
              // ],
              automaticallyImplyLeading: false,
              centerTitle: false,
              backgroundColor: Colors.transparent,
              floating: true,
              pinned: false,
              snap: false,
              title: Text(
                'Find A Stick',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ];
        },
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: cars,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                  slivers: snapshot.data!.docs.map((publicList) {
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
      ),
    );
  }

  SliverToBoxAdapter buildCar(
      QueryDocumentSnapshot<Object?> publicList, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
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
                if (FirebaseAuth.instance.currentUser?.uid == null)
                  Container()
                // TODO add like button to let user know if theyve liked current car
                else if (publicList['likedIds']
                    .contains(FirebaseAuth.instance.currentUser?.uid))
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(publicList.id)
                          .update({
                        'likedIds': FieldValue.arrayRemove(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                    },
                  )
                else
                  IconButton(
                    icon:
                        const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(publicList.id)
                          .update({
                        'likedIds': FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                    },
                  ),
              ],
            ),
            Text(
              '${publicList['price']}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${publicList['odometer']} Miles',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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

  //dispose
  @override
  void dispose() {
    super.dispose();
  }
}
