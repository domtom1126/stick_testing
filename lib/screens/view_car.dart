import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';

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

  ListView carModal() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 400, maxHeight: 200),
                child: FittedBox(
                  child: Image.network(widget.image),
                  fit: BoxFit.fitWidth,
                ),
              ),
              Row(
                children: [
                  Text('${widget.year} ',
                      style: TextStyle(
                          fontSize: 20,
                          color: HexColor('FFFFFF'),
                          fontWeight: FontWeight.bold)),
                  Text(
                    '${widget.make} ${widget.model}',
                    style: TextStyle(fontSize: 20, color: HexColor('FFFFFF')),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${widget.odometer} Miles',
                style: TextStyle(color: HexColor('FFFFFF'), fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.price,
                style: TextStyle(color: HexColor('FFFFFF'), fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              ReadMoreText(
                '${widget.description} ',
                moreStyle: TextStyle(
                    color: HexColor('FFFFFF'),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Read More',
                trimExpandedText: 'Read Less',
              ),
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
        ),
      ],
    );
  }
}
