import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/firebase_functions/post_listing.dart';
import 'package:testing/listing_bloc.dart';
import 'package:testing/screens/home.dart';
import 'package:testing/screens/post.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:testing/screens/sign_in.dart';

import '../bottom_bar.dart';

Widget textInputField(String label, TextEditingController controller,
    TextInputType keyboardType, String errorMessage, int maxLength, int lines) {
  return TextFormField(
    maxLines: lines,
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxLength),
    ],
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      errorStyle: TextStyle(
        color: Colors.orangeAccent,
        fontSize: 14.0,
      ),
      hintText: label,
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return errorMessage;
      }
      return null;
    },
  );
}

Widget numInputField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    String errorMessage,
    int maxLength,
    String numType) {
  return TextFormField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxLength),
      CurrencyTextInputFormatter(symbol: numType, decimalDigits: 0),
    ],
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      hintText: label,
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return errorMessage;
      }
      return null;
    },
  );
}

// _postingBloc.add(PostingEvent.postingSuccess());
class PostConfirm extends StatefulWidget {
  String make;
  String model;
  String year;
  String odometer;
  String price;
  String description;
  File image;

  PostConfirm({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.description,
    required this.image,
  });
  // Parameters need to go here

  @override
  _PostConfirmState createState() => _PostConfirmState();
}

class _PostConfirmState extends State<PostConfirm> {
  final _postListing = PostListing(
      make: '',
      model: '',
      year: '',
      odometer: '',
      price: '',
      description: '',
      image: '',
      dateAdded: '');
  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO change this height so its responsive
      height: 500,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO image goes here
            Center(
              child: Image(
                image: AssetImage(widget.image.path),
                height: 250,
                width: 250,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.year,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  ' ${widget.make} ${widget.model}',
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
            const Text('Are you sure you want to post this car?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TODO After post go to home screen
                ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .authStateChanges()
                          .listen((User? user) {
                        if (user == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Sign in to post'),
                                  content: const Text(
                                      'You need to be signed in to post a car'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Nevermind'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) =>
                                                SignInModal());
                                      },
                                      child: const Text('Sign In'),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          print('ok');
                          _postListing.addPost(
                              widget.make,
                              widget.model,
                              widget.year,
                              widget.odometer,
                              widget.price,
                              widget.description,
                              widget.image);
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (_) => false);
                          print('User is signed in!');
                        }
                      });
                    },
                    child: const Text('Yes')),

                ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    child: Center(child: Text('No'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
