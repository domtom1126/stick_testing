import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/firebase_functions/post_listing.dart';
import 'package:testing/listing_bloc.dart';

TextEditingController _makeController = TextEditingController();
TextEditingController _modelController = TextEditingController();
TextEditingController _yearController = TextEditingController();
TextEditingController _odometerController = TextEditingController();
TextEditingController _priceController = TextEditingController();

Widget makeInput() {
  return TextFormField(
    maxLength: 25,
    controller: _makeController,
    decoration: const InputDecoration(
      hintText: 'Make',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter make (Ford, Honda, etc)';
      }
      return null;
    },
  );
}

Widget modelInput() {
  return TextFormField(
    controller: _modelController,
    decoration: const InputDecoration(
      hintText: 'Model',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter model (Focus, Civic, etc)';
      }
      return null;
    },
  );
}

Widget yearInput() {
  return TextFormField(
    controller: _yearController,
    decoration: const InputDecoration(
      hintText: 'Year',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter year (2020, 1994, etc)';
      }
      return null;
    },
  );
}

Widget odometerInput() {
  return TextFormField(
    controller: _odometerController,
    decoration: const InputDecoration(
      hintText: 'Odometer',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter odometer';
      }
      return null;
    },
  );
}

Widget priceInput() {
  return TextFormField(
    controller: _priceController,
    decoration: const InputDecoration(
      hintText: 'Price',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter price';
      }
      return null;
    },
  );
}

// todo I am probably going to need to wrap this with a BlocBuilder or something
Widget addCarButton() {
  // final _postingBloc = BlocProvider.of<PostingBloc>(context);
  return ElevatedButton(
    onPressed: () => addCar(),
    child: Text('Add Car'),
  );
}

Future addCar() async {
  final _formKey = GlobalKey<FormState>();

  final postListing = PostListing(
      make: _makeController.text,
      model: _modelController.text,
      year: _yearController.text,
      odometer: _odometerController.text,
      price: _priceController.text,
      dateAdded: DateTime.now().toString());
  if (_formKey.currentState!.validate()) {
    // await Firestore.instance.collection('cars').add(postListing.toMap());
    // _postingBloc.add(PostingEvent.postingSuccess());
    // Navigator.pop(context);

  }
}
