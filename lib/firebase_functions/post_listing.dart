import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

import '../signin_controller.dart';

// * This would be like data_service.dart

class PostListing {
  String make = '';
  String model = '';
  String year = '';
  String odometer = '';
  String price = '';
  String description = '';
  String email = '';
  String image = '';
  String dateAdded = '';

  PostListing({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.description,
    required this.email,
    required this.image,
    required this.dateAdded,
  });

  addPost(String make, String model, String year, String odometer, String price,
      String description, File image) async {
    CollectionReference addPost =
        FirebaseFirestore.instance.collection('posts');
    final controller = Get.put(LoginController());
    final email = controller.googleAccount.value!.email;
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
          'description': description,
          'email': email,
          'image': value,
          'date_added': DateTime.now(),
          'isLiked': false,
        });
      });
    });
  }
}
