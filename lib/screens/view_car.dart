import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ViewCar extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  final List image;
  final String description;
  final String? receiverEmail;
  final bool reported;
  final String? docId;

  const ViewCar(
      this.make,
      this.model,
      this.year,
      this.price,
      this.odometer,
      this.image,
      this.description,
      this.receiverEmail,
      this.reported,
      this.docId,
      {Key? key})
      : super(key: key);

  @override
  _ViewCarState createState() => _ViewCarState();
}

class _ViewCarState extends State<ViewCar> {
  bool onLiked = false;
  final user = FirebaseAuth.instance.currentUser;

  Future sendReportedEmail() async {
    // Dont need to sign in
    // Need to get auth token
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    final userInfo = await GoogleAuthApi.signIn();
    if (userInfo == null) return;
    final auth = await userInfo.authentication;
    final token = auth.accessToken!;
    final smtpServer = gmailSaslXoauth2(user!.email.toString(), token);
    final message = Message()
      ..from = Address(userInfo.email, 'Find a Stick')
      ..recipients = ['domtom1126@gmail.com']
      ..subject = 'Car Reported'
      ..text = 'Car Reported';
    try {
      await send(message, smtpServer);
      // show dialog to confirm for 2 seconds
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text('Car Reported'),
      //       content: const Text('Thank you for reporting this car'),
      //       actions: <Widget>[
      //         ElevatedButton(
      //           child: const Text('Ok'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    } on MailerException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.docId)
        .get()
        .then((value) {
      if (value['likedIds'] != null) {
        if (value['likedIds'].contains(user?.uid)) {
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
    int _currentIndex = 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExpandImage(image: widget.image)));
            },
            child: SizedBox(
              height: 200,
              child: CarouselSlider(
                options: CarouselOptions(
                  onPageChanged: ((index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
                  // height: 200,
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,
                ),
                items: widget.image
                    .map(
                      (item) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 400,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: CachedNetworkImage(
                              imageUrl: item,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      // color: Colors.green,
                    )
                    .toList(),
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
              // TODO report vehicle for not being stick shift
              if (user?.uid != null)
                IconButton(
                  // TODO Make some sort of questionaire about why they are reporting and then send that in the report as well
                  onPressed: () async {
                    CollectionReference reportCarToFirebase =
                        FirebaseFirestore.instance.collection('reported_cars');
                    reportCarToFirebase.add({'car_id': widget.docId});
                    // Update the original post and change the 'reported' bool to true
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.docId)
                        .update({'reported': true});
                  },
                  icon: const Icon(Icons.error),
                ),
              if (widget.reported == true)
                Flexible(
                  child: Text(
                    'Vehicle has already been reported',
                    style: TextStyle(color: HexColor('000000'), fontSize: 14),
                  ),
                )
              else
                Container(),
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
                      child: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () async {
                        await HapticFeedback.heavyImpact();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.black45,
                                title: const Text('Are you sure?'),
                                content: Text(
                                    'Do you want to remove this car from your likes?',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(widget.docId)
                                          .update({
                                        'likedIds':
                                            FieldValue.arrayRemove([user?.uid])
                                      }).then((value) {
                                        setState(() {
                                          onLiked = false;
                                        });
                                      });
                                      // Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  )
                else if (onLiked == false)
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await HapticFeedback.heavyImpact();
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.docId)
                            .update({
                          'likedIds': FieldValue.arrayUnion([user?.uid])
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
                      backgroundColor: HexColor('EE6C4D'),
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
                        // sendEmail(widget.receiverEmail, widget.year,
                        //     widget.make, widget.model, widget.price);
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

// sendEmail(
//     String? email, String? year, String? make, String? model, String? price) {
//   String? encodeQueryParameters(Map<String, String> params) {
//     return params.entries
//         .map((e) =>
//             '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
//         .join('&');
//   }

//   final emailLaunchUri = Uri(
//     scheme: 'mailto',
//     path: email,
//     query: encodeQueryParameters(<String, String>{
//       'subject': 'Hi! Is your $year $make $model still available?',
//       'body':
//           'I found your car for sale on Find a Stick. Is it still available at the price of $price',
//     }),
//   );
//   launch(emailLaunchUri.toString());
// }

class ExpandImage extends StatefulWidget {
  final List image;
  const ExpandImage({Key? key, required this.image}) : super(key: key);

  @override
  State<ExpandImage> createState() => _ExpandImageState();
}

class _ExpandImageState extends State<ExpandImage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Images'),
          ),
      body: InteractiveViewer(
        panEnabled: true, // Set it to false
        minScale: 0.5,
        maxScale: 2,
        child: Center(
          child: CarouselSlider(
            options: CarouselOptions(
              onPageChanged: ((index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
              // height: 200,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
            ),
            items: widget.image
                .map(
                  (item) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 400,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: CachedNetworkImage(
                          imageUrl: item,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  // color: Colors.green,
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
