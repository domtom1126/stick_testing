import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

final String uid = FirebaseAuth.instance.currentUser!.uid;

class ViewCar extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  final String image;
  final String description;
  final String? receiverEmail;
  final String? docId;

  ViewCar(this.make, this.model, this.year, this.price, this.odometer,
      this.image, this.description, this.receiverEmail, this.docId);

  @override
  _ViewCarState createState() => _ViewCarState();
}

class _ViewCarState extends State<ViewCar> {
  bool onLiked = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.docId)
        .get()
        .then((value) {
      if (value['likedIds'] != null) {
        if (value['likedIds'].contains(uid)) {
          setState(() {
            onLiked = true;
          });
        }
      }
    });
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
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExpandImage(image: widget.image)));
            },
            child: Hero(
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                '${widget.year} ${widget.make} ${widget.model}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.price,
            style: Theme.of(context).textTheme.bodyMedium,
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
          Divider(
            color: HexColor('ffffff'),
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
                if (onLiked)
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      child: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.docId)
                            .update({
                          'likedIds': FieldValue.arrayRemove([uid])
                        });
                        setState(() {
                          onLiked = false;
                        });
                      },
                    ),
                  )
                else if (onLiked == false)
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.docId)
                            .update({
                          'likedIds': FieldValue.arrayUnion([uid])
                        });
                        setState(() {
                          onLiked = true;
                        });
                      },
                    ),
                  ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: HexColor('EE6C4D'),
                    ),
                    child: const Icon(Icons.message),
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        // show dialog to login
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login to send message'),
                              content:
                                  const Text('Go to the profile page to login'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Login'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // navigate to profile page
                                    Navigator.of(context).pushNamed('/profile');
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        sendEmail(widget.receiverEmail);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandImage extends StatefulWidget {
  final String image;
  const ExpandImage({Key? key, required this.image}) : super(key: key);

  @override
  State<ExpandImage> createState() => _ExpandImageState();
}

class _ExpandImageState extends State<ExpandImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
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
    );
  }
}
