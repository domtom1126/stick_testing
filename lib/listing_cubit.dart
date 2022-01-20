import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/listing.dart';

import 'firebase_functions/get_listings.dart';
import 'firebase_functions/post_listing.dart';

class ListingCubit extends Cubit<List<Listing>> {
  final GetListing _postListing = GetListing();
  ListingCubit() : super([]);

  void getListing() async => emit(await _postListing.getListing());
}
