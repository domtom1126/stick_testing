import 'package:flutter/material.dart';

class ViewCar extends StatefulWidget {
  // const ViewCar({Key? key}) : super(key: key);
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  final String description;

  // TODO add images bro
  // final String image;

  const ViewCar(this.make, this.model, this.year, this.price, this.odometer,
      this.description);

  @override
  _ViewCarState createState() => _ViewCarState();
}

class _ViewCarState extends State<ViewCar> {
  @override
  Widget build(BuildContext buildContext) {
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
                    Text('${widget.year} ',
                        style: const TextStyle(fontSize: 20)),
                    Text(
                      '${widget.make} ${widget.model}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Text(widget.price),
                Text('${widget.odometer} Miles'),
                Text(widget.description),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                                  title: Text('This car was liked'),
                                  content: Text('This car was liked'),
                                )),
                        child: const Icon(Icons.favorite)),
                    const ElevatedButton(
                        onPressed: null, child: Icon(Icons.email)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
