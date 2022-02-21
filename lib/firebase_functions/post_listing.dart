import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:testing/listing.dart';

// * This would be like data_service.dart

class PostListing {
  String id = '';
  String make = '';
  String model = '';
  String year = '';
  String odometer = '';
  String price = '';
  String description = '';
  String image = '';
  String dateAdded = '';

  PostListing({
    // required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.description,
    required this.image,
    required this.dateAdded,
  });

  addPost(String make, String model, String year, String odometer, String price,
      String description, String image) async {
    // TODO Images are gonna upload here
    final snapshot = firebase_storage.FirebaseStorage.instance
        .ref('images/')
        .putFile(File(image))
        .snapshot;
    final imageURL = await snapshot.ref.getDownloadURL();
    CollectionReference addPost =
        FirebaseFirestore.instance.collection('posts');
    await addPost.add({
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'odometer': odometer,
      'price': price,
      'description': description,
      'image': imageURL,
      'date_added': DateTime.now(),
    });
  }
}
