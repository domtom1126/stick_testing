import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/firebase_functions/post_listing.dart';
import 'package:testing/listing_bloc.dart';
import 'package:testing/screens/post.dart';

TextEditingController _makeController = TextEditingController();
TextEditingController _modelController = TextEditingController();
TextEditingController _yearController = TextEditingController();
TextEditingController _odometerController = TextEditingController();
TextEditingController _priceController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();

Widget makeInput() {
  return TextFormField(
    controller: _makeController,
    decoration: const InputDecoration(
      hintText: 'Make',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter make (Ford, Honda, etc)';
      }
      return _makeController.text;
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
      return _modelController.text;
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
      return _yearController.text;
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
      return _odometerController.text;
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

Widget descriptionInput() {
  return TextFormField(
    controller: _descriptionController,
    maxLength: null,
    decoration: const InputDecoration(
      hintText: 'Description',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Enter price';
      }
      return _descriptionController.text;
    },
  );
}

Widget addCarButton() {
  return ElevatedButton(onPressed: () => addCar(), child: Text('Add Car'));
}

Future addCar() async {
  final _formKey = GlobalKey<FormState>();

  final postListing = PostListing(
      make: _makeController.text,
      model: _modelController.text,
      year: _yearController.text,
      odometer: _odometerController.text,
      price: _priceController.text,
      description: _descriptionController.text,
      dateAdded: DateTime.now().toString());
  postListing.addPost();
}
// _postingBloc.add(PostingEvent.postingSuccess());

Widget postConfirm() {
  return Container(
    // TODO change this height so its responsive
    height: 500,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_yearController.text, style: const TextStyle(fontSize: 20)),
              Text(
                '${_makeController.text} ${_modelController.text}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          Text(_priceController.text),
          Text('${_odometerController.text} Miles'),
          Text(_descriptionController.text),
          const SizedBox(
            height: 20,
          ),
          const Text('Are you sure you want to post this car?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ElevatedButton(onPressed: null, child: Text('Yes')),
              ElevatedButton(onPressed: null, child: Text('No')),
            ],
          ),
        ],
      ),
    ),
  );
}
