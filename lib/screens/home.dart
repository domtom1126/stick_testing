import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/search.dart';
import 'package:find_a_stick/screens/view_car.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// TODO Add explain page for first time runners
// TODO * Add package is_first_run

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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: HexColor('EE6C4D'),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LiveSearch()));
                  },
                ),
              ],
              automaticallyImplyLeading: false,
              centerTitle: false,
              backgroundColor: Colors.transparent,
              floating: true,
              pinned: false,
              snap: false,
              title: Column(
                children: const [
                  Text(
                    'Find A Stick',
                  ),
                  Text(
                    'Location: Not set',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter buildCar(
      QueryDocumentSnapshot<Object?> publicList, BuildContext context) {
    int _currentIndex = 0;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => showCarModal(context, publicList),
              child: SizedBox(
                height: 200,
                child: CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged: ((index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }),
                    // height: 250,
                    viewportFraction: 1.0,
                    enlargeCenterPage: true,
                  ),
                  items: publicList['images']
                      .map<Widget>(
                        (item) => buildImageBox(item),
                      )
                      .toList(),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),

            Row(
              children: [
                Text('${publicList['year']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
                Text(
                  ' ${publicList['make']} ${publicList['model']}',
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
                      OneSignal.shared.setExternalUserId(publicList['id']);
                      OneSignal.shared.postNotification(OSCreateNotification(
                          content: 'This is a test notification',
                          playerIds: [publicList['id']]));
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
            Row(
              children: [
                Text(
                  '\$${publicList['price']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  width: 10,
                ),
                if (publicList['previous_price'] == 0)
                  Container()
                else
                  Text(
                    '\$${publicList['previous_price']}',
                    style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),
                  )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  '${publicList['odometer']} Miles',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                if (publicList['sold'])
                  const Text(
                    'Sold!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                else
                  Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ClipRRect buildImageBox(item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 400,
        child: FittedBox(
          fit: BoxFit.cover,
          child: CachedNetworkImage(
            imageUrl: item,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCarModal(
      BuildContext context, QueryDocumentSnapshot<Object?> publicList) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: HexColor('2B2E34'),
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
        publicList['images'],
        publicList['description'],
        publicList['email'],
        publicList['reported'],
        publicList.id,
      ),
    );
  }
}
