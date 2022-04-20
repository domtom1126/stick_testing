import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUserCar extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  final String image;
  final String description;
  const EditUserCar(
      {Key? key,
      required this.make,
      required this.model,
      required this.year,
      required this.price,
      required this.odometer,
      required this.image,
      required this.description})
      : super(key: key);

  @override
  State<EditUserCar> createState() => _EditUserCarState();
}

class _EditUserCarState extends State<EditUserCar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Car'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: widget.make,
            decoration: const InputDecoration(
              labelText: 'Make',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: widget.model,
            decoration: const InputDecoration(
              labelText: 'Model',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: widget.year,
            decoration: const InputDecoration(
              labelText: 'Year',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: widget.price,
            decoration: const InputDecoration(
              labelText: 'Price',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: widget.odometer,
            decoration: const InputDecoration(
              labelText: 'Odometer',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: widget.description,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              null;
            },
          ),
        ],
      ),
    );
  }
}
