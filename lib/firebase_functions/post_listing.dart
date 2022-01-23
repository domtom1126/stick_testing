import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/listing.dart';

// * This would be like data_service.dart
class PostListing {
  late final String id;
  late final String make;
  late final String model;
  late final String year;
  late final String odometer;
  late final String price;
  late final String dateAdded;

  PostListing({
    // required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.dateAdded,
  });

  addPost() async {
    CollectionReference addPost =
        FirebaseFirestore.instance.collection('posts');
    await addPost.add({
      // 'id': id,
      'make': make,
      'model': model,
      'year': year,
      'odometer': odometer,
      'price': price,
      'date_added': dateAdded,
    });
    return addPost;
  }
}
