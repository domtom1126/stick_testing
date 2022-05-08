import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class EditUserCar extends StatefulWidget {
  final String make;
  final String model;
  final String year;
  final String price;
  final String odometer;
  final String image;
  final String description;
  final String id;
  const EditUserCar(
      {Key? key,
      required this.make,
      required this.model,
      required this.year,
      required this.price,
      required this.odometer,
      required this.image,
      required this.description,
      required this.id})
      : super(key: key);

  @override
  State<EditUserCar> createState() => _EditUserCarState();
}

class _EditUserCarState extends State<EditUserCar> {
  final _formKey = GlobalKey<FormState>();

  File? pickedImage;
  Future pickImage() async {
    final _imagePicker = ImagePicker();
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    final imageTemp = File(pickedImage!.path);
    setState(() => this.pickedImage = imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _makeController =
        TextEditingController(text: widget.make);
    final TextEditingController _modelController =
        TextEditingController(text: widget.model);
    final TextEditingController _yearController =
        TextEditingController(text: widget.year);
    final TextEditingController _odometerController =
        TextEditingController(text: widget.odometer);
    final TextEditingController _priceController =
        TextEditingController(text: widget.price);
    final TextEditingController _descriptionController =
        TextEditingController(text: widget.description);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Car'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              controller: _makeController,
              keyboardAppearance: Brightness.dark,
              decoration: InputDecoration(
                labelText: 'Make',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Make',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a make';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              controller: _modelController,
              keyboardAppearance: Brightness.dark,
              decoration: InputDecoration(
                labelText: 'Model',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Model',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a make';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              keyboardType: TextInputType.number,
              keyboardAppearance: Brightness.dark,
              controller: _yearController,
              decoration: InputDecoration(
                labelText: 'Year',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Year',
              ),
              validator: (value) {
                if (value!.length != 4) {
                  return 'Please enter a valid year';
                } else if (value[0] == '0' ||
                    value[0] == '3' ||
                    value[0] == '4' ||
                    value[0] == '5' ||
                    value[0] == '6' ||
                    value[0] == '7' ||
                    value[0] == '8' ||
                    value[0] == '9') {
                  return 'Enter 2 digit valid year';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              controller: _odometerController,
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Odometer',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Miles',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a miles';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // TODO When user changes price add price to list in firebase to show history of price changes
            TextFormField(
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                CurrencyTextInputFormatter(symbol: '\$', decimalDigits: 0),
              ],
              controller: _priceController,
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Price',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: _descriptionController,
              keyboardAppearance: Brightness.dark,
              decoration: InputDecoration(
                labelText: 'Description',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'Description',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Show Image
            // pickedImage != null
            ElevatedButton(
              onPressed: () => pickImage(),
              child: const Text('Change Image'),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Container(),

            // * This actually works! but for now just do single image
            // CarouselSlider.builder(
            //   options: CarouselOptions(height: 200),
            //   itemCount: pickedImage.length,
            //   itemBuilder: (context, index, realIndex) {
            //     final singleImage = pickedImage[index];

            //     return Container(
            //       margin: EdgeInsets.all(5.0),
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //         child: Image.file(
            //           singleImage!,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // save data to post
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.id)
                        .update({
                      'make': _makeController.text,
                      'model': _modelController.text,
                      'year': _yearController.text,
                      'odometer': _odometerController.text,
                      'price': _priceController.text,
                      'description': _descriptionController.text,
                      'image': widget.image,
                    }).whenComplete(() {
                      const snackBar = SnackBar(
                        content: Text('Your post has been updated'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // navigate to profile page
                    });
                  }
                },
                child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
