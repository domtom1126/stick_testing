import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../listing.dart';
import '../listing_cubit.dart';

class ListingsView extends StatelessWidget {
  const ListingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Stick'),
      ),
      body: BlocBuilder<ListingCubit, List<Listing>>(
          builder: (context, listings) {
        return ListView.builder(
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing = listings[index];
            return ListTile(
              title: Text(listing.make),
              subtitle: Text(listing.model),
              onTap: () {
                null;
              },
            );
          },
        );
      }),
    );
  }
}
