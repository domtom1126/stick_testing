import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

sendEmail(String? email) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(
        <String, String>{'subject': 'Example Subject & Symbols are allowed!'}),
  );
  launch(emailLaunchUri.toString());
}

// String _currentUser = FirebaseAuth.instance.currentUser!.uid;

class ViewCar extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  final String image;
  final String description;
  final String? receiverEmail;

  ViewCar(this.make, this.model, this.year, this.price, this.odometer,
      this.image, this.description, this.receiverEmail);

  @override
  _ViewCarState createState() => _ViewCarState();
}

class _ViewCarState extends State<ViewCar> {
  bool onLiked = false;

  @override
  void initState() {
    // likesRef = FirebaseFirestore.instance.collection('likes').doc(_currentUser);
    super.initState();
    // likesRef!.get().then((value) => data = value.data as Map<String, dynamic>?);
  }

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
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                    setState(() {
                      onLiked = !onLiked;
                    });
                  },
                ),
                ElevatedButton(
                    onPressed: () => sendEmail(widget.receiverEmail),
                    child: const Icon(Icons.email)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
