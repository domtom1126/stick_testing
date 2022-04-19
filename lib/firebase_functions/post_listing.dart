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
  String description = '';
  List<File> images = [];
  String dateAdded = '';

  PostListing({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.description,
    required this.images,
    required this.dateAdded,
  });

  addPost(String make, String model, String year, String odometer, String price,
      String description, List<File> images) async {
    CollectionReference addPost =
        FirebaseFirestore.instance.collection('posts');
    String? email = FirebaseAuth.instance.currentUser!.email;
    for (var img in images) {
      final pickedImage = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${img.path}');
      await pickedImage.putFile(img).whenComplete(() async {
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
            'likedIds': [],
            'id': FirebaseAuth.instance.currentUser!.uid,
            'sold': false,
          });
        });
      });
    }
    // await images.putFile(images).whenComplete(() async {
    //   await pickedImage.getDownloadURL().then((value) {
    //     addPost.add({

    //     });
    //   });
    // });
  }

  addMake(String make) async {
    CollectionReference addMake =
        FirebaseFirestore.instance.collection('makes');
    addMake.add({
      'make': make,
    });
  }
}
