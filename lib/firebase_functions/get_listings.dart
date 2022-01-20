import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../listing.dart';

class GetListing {
  Future<CollectionReference<Listing>> getListing() async {
    try {
      final latestPost = FirebaseFirestore.instance
          .collection('posts')
          .withConverter<Listing>(
            fromFirestore: (snapshot, _) => Listing.fromJson(snapshot.data()!),
            toFirestore: (listing, _) => listing.toJson(),
          );
      return latestPost;
    } catch (e) {
      rethrow;
    }
  }
}
