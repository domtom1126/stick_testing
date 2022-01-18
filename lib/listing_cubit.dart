import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/listing.dart';

import 'firebase_functions/post_listing.dart';

class ListingCubit extends Cubit<List<NewListing>> {
  final PostListing _postListing = PostListing();
  ListingCubit() : super([]);

  void addListing() async => emit(await _postListing.postCar());
}
