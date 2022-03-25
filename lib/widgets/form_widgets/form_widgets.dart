import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import '../../firebase_functions/post_listing.dart';
import '../../signin_controller.dart';

TextFormField textInputField(String label, TextEditingController controller,
    TextInputType keyboardType, String errorMessage, int maxLength, int lines) {
  return TextFormField(
    maxLines: lines,
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxLength),
    ],
    keyboardType: keyboardType,
    keyboardAppearance: Brightness.dark,
    controller: controller,
    style: TextStyle(color: HexColor('FFFFFF')),
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      errorStyle: const TextStyle(
        color: Colors.orangeAccent,
        fontSize: 14.0,
      ),
      hintStyle: TextStyle(color: HexColor('FFFFFF')),
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

TextFormField numInputField(
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
    keyboardAppearance: Brightness.dark,
    controller: controller,
    style: TextStyle(color: HexColor('FFFFFF')),
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      hintStyle: TextStyle(color: HexColor('FFFFFF')),
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

// final googleSignIn = GoogleSignIn();

// _postingBloc.add(PostingEvent.postingSuccess());
class PostConfirm extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String odometer;
  final String price;
  final String email;
  final String description;
  final File image;

  PostConfirm({
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    required this.price,
    required this.email,
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
      email: '',
      image: '',
      dateAdded: '');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    onPressed: () async {
                      await _postListing.addPost(
                          widget.make,
                          widget.model,
                          widget.year,
                          widget.odometer,
                          widget.price,
                          widget.description,
                          widget.image);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (_) => false);
                    },
                    child: const Text('Yes')),

                ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Center(child: Text('No'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
