import 'package:flutter/material.dart';

class ViewCar extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  // final String image;
  final String description;

  const ViewCar(this.make, this.model, this.year, this.price, this.odometer,
      this.description);

  @override
  _ViewCarState createState() => _ViewCarState();
}

class _ViewCarState extends State<ViewCar> {
  bool onLiked = false;
  @override
  Widget build(BuildContext buildContext) {
    return carModal();
  }

  SizedBox carModal() {
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
                Placeholder(
                  fallbackHeight: 250,
                  fallbackWidth: 250,
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
                      style: ElevatedButton.styleFrom(
                        primary: onLiked ? Colors.red : Colors.grey,
                      ),
                      child: Icon(Icons.favorite),
                      onPressed: () {
                        setState(() {
                          onLiked = !onLiked;
                        });
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 2),
                          content: const Text('Car Liked'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                    ElevatedButton(
                        onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Text('Email the Owner'),
                                content: Text('Email the Owner'),
                              ),
                            ),
                        child: Icon(Icons.email)),
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
