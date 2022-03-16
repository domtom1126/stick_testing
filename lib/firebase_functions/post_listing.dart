import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/listing.dart';
import 'package:testing/signin_controller.dart';

// * This would be like data_service.dart

class PostListing {
  String make = '';
  String model = '';
  String year = '';
  String odometer = '';
  String price = '';
  String description = '';
  String email = '';
  // String image = '';
  String dateAdded = '';

  PostListing({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.description,
    required this.email,
    // required this.image,
    required this.dateAdded,
  });

  addPost(String make, String model, String year, String odometer, String price,
      String description) async {
    // TODO Images are gonna upload here
    // final snapshot = firebase_storage.FirebaseStorage.instance
    //     .ref()
    //     .child('images/')
    //     .putFile(File(image.path))
    //     .snapshot;
    // final imageURL = await snapshot.ref.getDownloadURL();
    CollectionReference addPost =
        FirebaseFirestore.instance.collection('posts');
    final controller = Get.put(LoginController());
    final email = controller.googleAccount.value!.email;
    await addPost.add({
      'make': make,
      'model': model,
      'year': year,
      'odometer': odometer,
      'price': price,
      'description': description,
      'email': email,
      // 'image': imageURL,
      'date_added': DateTime.now(),
    });
  }
}
