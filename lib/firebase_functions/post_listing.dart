import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  // String image = '';
  String dateAdded = '';

  PostListing({
    // required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.description,
    // required this.image,
    required this.dateAdded,
  });

  addPost(String make, String model, String year, String odometer, String price,
      String description, String image) async {
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
      'image': image,
      'date_added': DateTime.now(),
    });
  }
}
