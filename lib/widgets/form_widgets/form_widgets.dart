import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing/firebase_functions/post_listing.dart';

TextEditingController _makeController = TextEditingController();
TextEditingController _modelController = TextEditingController();
TextEditingController _yearController = TextEditingController();
TextEditingController _odometerController = TextEditingController();
TextEditingController _priceController = TextEditingController();

final _formKey = GlobalKey<FormState>();
Widget formWidget() {
  return Form(
    key: _formKey,
    child: Column(children: [
      makeInput(),
      modelInput(),
      yearInput(),
      odometerInput(),
      priceInput(),
      addCarButton(),
    ]),
  );
}

Widget makeInput() {
  return TextFormField(
    controller: _makeController,
    decoration: const InputDecoration(
      hintText: 'Make',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter some text';
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
        return 'Please enter some text';
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
        return 'Please enter some text';
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
        return 'Please enter some text';
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
        return 'Please enter some text';
      }
      return null;
    },
  );
}

// todo I am probably going to need to wrap this with a BlocBuilder or something
Widget addCarButton() {
  return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          addCar();
        }
      },
      child: Text('Add Car'));
}

Future addCar() async {
  final postListing = PostListing(
      make: _makeController.text,
      model: _modelController.text,
      year: _yearController.text,
      odometer: _odometerController.text,
      price: _priceController.text,
      dateAdded: DateTime.now().toString());
  CollectionReference addPost = FirebaseFirestore.instance.collection('posts');
  if (_formKey.currentState!.validate()) {
    postListing.addPost();
    // await addPost.add({
    //   'make': _makeController.text,
    //   'model': _modelController.text,
    //   'year': _yearController.text,
    //   'odometer': _odometerController.text,
    //   'price': _priceController.text,
    //   'date_added': DateTime.now(),
    // });

  } else {
    // todo check is user has filled all fields
    print('invalid');
  }
}
