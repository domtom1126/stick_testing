import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/listing.dart';
// * This would be like data_service.dart
class PostListing {
  late final String id;
  late final String make;


  CollectionReference add_post =
      FirebaseFirestore.instance.collection('posts');
  Future<List<NewListing>> postCar() {
    // todo this will post to firebase
    try {
      return add_post.add({

      })
    }
  }
}