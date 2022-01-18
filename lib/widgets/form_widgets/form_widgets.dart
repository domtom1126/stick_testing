import 'package:flutter/material.dart';

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
        print(_makeController.text);
      },
      child: Text('Add Car'));
}
