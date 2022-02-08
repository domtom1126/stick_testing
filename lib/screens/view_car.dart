import 'package:flutter/material.dart';

// TODO make this a class and then add like button and email stuff here

Widget viewCar(String make, String model, String year, String price,
    String odometer, String description) {
  return Container(
    // TODO change this height so its responsive
    height: 500,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Placeholder(
            fallbackHeight: 250,
          ),
          Row(
            children: [
              Text('$year ', style: const TextStyle(fontSize: 20)),
              Text(
                '$make $model',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          Text(price),
          Text('$odometer Miles'),
          Text('description'),
        ],
      ),
    ),
  );
}
