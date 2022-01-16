import 'package:flutter/material.dart';

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

Widget addCarButton() {
  return ElevatedButton(onPressed: () {}, child: const Text('Add Car'));
}
