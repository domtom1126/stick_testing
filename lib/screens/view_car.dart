import 'package:flutter/material.dart';

class ViewCar extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  final String image;
  final String description;

  ViewCar(this.make, this.model, this.year, this.price, this.odometer,
      this.image, this.description);

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
                Image.network(widget.image),
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
                      child: const Icon(Icons.favorite),
                      onPressed: () {
                        // get current user id
                        // add to favorites
                        // CollectionReference addToLiked =
                        //     FirebaseFirestore.instance.collection('${c} liked');
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
                        child: const Icon(Icons.email)),
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
