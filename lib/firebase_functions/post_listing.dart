import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PostListing {
  String make = '';
  String model = '';
  String year = '';
  String odometer = '';
  String price = '';
  String zipCode = '';
  String description = '';
  List<File> images;
  String dateAdded = '';

  PostListing({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.zipCode,
    required this.description,
    required this.images,
    required this.dateAdded,
  });

  addPost(String make, String model, String year, String odometer, String price,
      String zipCode, String description, List<File> images) async {
    List<String> imageUrlList = [];
    CollectionReference addPost =
        FirebaseFirestore.instance.collection('posts');
    String? email = FirebaseAuth.instance.currentUser!.email;
    for (var image in images) {
      final pickedImage = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$image');
      await pickedImage.putFile(image).whenComplete(() async {
        await pickedImage.getDownloadURL().then((value) {
          imageUrlList.add(value);
        });
      });
    }
    addPost.add({
      'make': make,
      'model': model,
      'year': year,
      'odometer': odometer,
      'price': price,
      'previous_price': 0,
      'zipCode': zipCode,
      'description': description,
      'email': email,
      'images': imageUrlList,
      'date_added': DateTime.now(),
      'likedIds': [],
      'id': FirebaseAuth.instance.currentUser!.uid,
      'sold': false,
      'reported': false,
    });
  }

  // * Puts the make of each post in db for search purposes
  addMake(String make) async {
    // Before adding make to make collection, check if it already exists
    // in the collection
    QuerySnapshot makeQuery = await FirebaseFirestore.instance
        .collection('makes')
        .where('make', isEqualTo: make)
        .get();
    // If make already exists, don't add it
    if (makeQuery.docs.isNotEmpty) {
      return;
    }

    CollectionReference addMake =
        FirebaseFirestore.instance.collection('makes');
    // * Adds make to firebase
    addMake.add({
      'make': make,
    });
  }
}
