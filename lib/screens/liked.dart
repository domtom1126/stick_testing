import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Liked extends StatefulWidget {
  const Liked({Key? key}) : super(key: key);

  @override
  _LikedState createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  final cars = FirebaseFirestore.instance
      .collection('posts')
      .where('likedIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Liked')),
        body: StreamBuilder(
          stream: cars,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                  children: snapshot.data!.docs.map((userLikedCars) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: userLikedCars['image'],
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),

                      Text(
                        '${userLikedCars['year']} ${userLikedCars['make']} ${userLikedCars['model']}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${userLikedCars['price']}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${userLikedCars['odometer']} Miles',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }).toList());
            } else {
              return const Center(
                child: Text('You haven\'t liked any cars yet'),
              );
            }
          },
        ));
  }
}
