import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/firebase_functions/post_listing.dart';
import 'package:testing/listing_bloc.dart';
import 'package:testing/screens/home.dart';
import 'package:testing/screens/post.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

Widget textInputField(String label, TextEditingController controller,
    TextInputType keyboardType, String errorMessage, int maxLength) {
  return TextFormField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxLength),
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
                      _postListing.addPost(
                          widget.make,
                          widget.model,
                          widget.year,
                          widget.odometer,
                          widget.price,
                          widget.description,
                          widget.image.toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
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

// Widget postConfirm() {
//   return Container(
//     // TODO change this height so its responsive
//     height: 500,
//     width: double.infinity,
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Placeholder(
//             fallbackHeight: 250,
//             fallbackWidth: 300,
//           ),
//           Row(
//             children: [
//               Text(
//                 _yearController.text,
//                 style: const TextStyle(fontSize: 20),
//               ),
//               Text(
//                 ' ${_makeController.text}${_modelController.text}',
//                 style: const TextStyle(fontSize: 20),
//               ),
//             ],
//           ),
//           Text(_priceController.text),
//           Text('${_odometerController.text} Miles'),
//           Text(_descriptionController.text),
//           const SizedBox(
//             height: 20,
//           ),
//           const Text('Are you sure you want to post this car?'),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                   onPressed: () => addCar(), child: const Text('Yes')),
//               ElevatedButton(onPressed: , child: Text('No')),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
