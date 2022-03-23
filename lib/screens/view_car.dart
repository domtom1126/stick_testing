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

  SingleChildScrollView carModal() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'carImage',
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('${widget.year} ',
                  style: TextStyle(
                      fontSize: 24,
                      color: HexColor('FFFFFF'),
                      fontWeight: FontWeight.bold)),
              Text(
                '${widget.make} ${widget.model}',
                style: TextStyle(
                    fontSize: 24,
                    color: HexColor('FFFFFF'),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.price,
            style: TextStyle(
                color: HexColor('FFFFFF'),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '${widget.odometer} Miles',
            style: TextStyle(color: HexColor('FFFFFF'), fontSize: 16),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Some Details',
            style: TextStyle(
                color: HexColor('FFFFFF'),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          ReadMoreText(
            '${widget.description} ',
            style: TextStyle(color: HexColor('FFFFFF'), fontSize: 18),
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
          SizedBox(
            height: 100,
            child: Row(
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
          ),
        ],
      ),
    );
  }

  Hero _buildCarImage(BuildContext context) {
    return Hero(
      tag: 'carImage',
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Image.network(
          widget.image,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class BuildCarImage extends StatelessWidget {
  const BuildCarImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: 'carImage',
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
