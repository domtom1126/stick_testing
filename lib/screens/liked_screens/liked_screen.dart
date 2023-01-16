import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/view_car.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  final cars = FirebaseFirestore.instance
      .collection('posts')
      .where('likedIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cars,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomScrollView(
              slivers: snapshot.data!.docs.map((publicList) {
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
                            onTap: () =>
                                {showCarModal(context, publicList), null},
                            child: CarouselSlider(
                              options: CarouselOptions(
                                onPageChanged: ((index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                }),
                                // height: 200,
                                viewportFraction: .9,
                                enlargeCenterPage: true,
                              ),
                              items: publicList['images']
                                  .map<Widget>(
                                    (item) => ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: 400,
                                        child: CachedNetworkImage(
                                          imageUrl: item,
                                          fit: BoxFit.fitWidth,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    // color: Colors.green,
                                  )
                                  .toList(),
                            ),
                            // child: CachedNetworkImage(
                            //   imageUrl: publicList['images'],
                            //   fit: BoxFit.fitWidth,
                            //   placeholder: (context, url) =>
                            //       const Center(child: CircularProgressIndicator()),
                            //   errorWidget: (context, url, error) =>
                            //       const Icon(Icons.error),
                            // ),
                          )),
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
                            icon: const Icon(Icons.favorite_border,
                                color: Colors.white),
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
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
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
          }).toList());
        });
  }

  Future showCarModal(
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
