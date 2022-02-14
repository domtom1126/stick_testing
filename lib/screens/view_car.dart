import 'package:flutter/material.dart';

// TODO make this a class and then add like button and email stuff here

Widget viewCar(String make, String model, String year, String price,
    String odometer, String description) {
  return SizedBox(
    height: 500,
    child: Column(
      // TODO change this height so its responsive
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Placeholder(
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
              Text(description),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => AlertDialog(
                            title: Text('this was liked'),
                            content: Container(
                              child: Text('This was liked'),
                            ),
                          ),
                      child: Icon(Icons.favorite)),
                  ElevatedButton(onPressed: null, child: Icon(Icons.email)),
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}
