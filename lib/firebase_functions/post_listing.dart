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
  File image;
  String dateAdded = '';

  PostListing({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.zipCode,
    required this.description,
    required this.image,
    required this.dateAdded,
  });

  addPost(String make, String model, String year, String odometer, String price,
      String zipCode, String description, File image) async {
    CollectionReference addPost =
        FirebaseFirestore.instance.collection('posts');
    String? email = FirebaseAuth.instance.currentUser!.email;
    final pickedImage = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${image.path}');
    await pickedImage.putFile(image).whenComplete(() async {
      await pickedImage.getDownloadURL().then((value) {
        addPost.add({
          'make': make,
          'model': model,
          'year': year,
          'odometer': odometer,
          'price': price,
          'zipCode': zipCode,
          'description': description,
          'email': email,
          'image': value,
          'date_added': DateTime.now(),
          'likedIds': [],
          'id': FirebaseAuth.instance.currentUser!.uid,
          'sold': false,
          'reported': false,
        });
      });
    });
  }

  // * Puts the make of each post in db for search purposes
  addMake(String make) async {
    CollectionReference addMake =
        FirebaseFirestore.instance.collection('makes');
    addMake.add({
      'make': make,
    });
  }
}
