import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/listing.dart';

// * This would be like data_service.dart
class PostListing {
  String id = '';
  String make = '';
  String model = '';
  String year = '';
  String odometer = '';
  String price = '';
  String dateAdded = '';

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
