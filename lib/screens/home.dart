import 'package:flutter/material.dart';
import 'package:testing/firebase_functions/get_listings.dart';

import '../listing.dart';
import '../listing_cubit.dart';
import 'listings_view.dart';

// todo this page will get the most recent listings. Wrap with BlocBuilder
class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final listingView = ListingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listingView.getListings(),
    );
  }
}
