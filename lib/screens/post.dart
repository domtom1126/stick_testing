import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/listing_bloc.dart';
import 'package:testing/widgets/form_widgets/form_widgets.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _odometerController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image;
  Future pickImage() async {
    final _imagePicker = ImagePicker();
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    final imageTemp = File(image!.path);
    setState(() => this.image = imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Container(
            // height: 400,
            // decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.grey,
            //     ),
            //     borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ListView(
              children: [
                textInputField('Make', _makeController, TextInputType.text,
                    'Enter make', 20),
                const SizedBox(height: 20),
                textInputField('Model', _modelController, TextInputType.text,
                    'Enter model', 20),
                const SizedBox(height: 20),
                TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  controller: _yearController,
                  decoration: const InputDecoration(
                    hintText: 'Year',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                numInputField('Odometer', _odometerController,
                    TextInputType.number, 'Enter odometer', 10, ''),
                const SizedBox(height: 20),
                numInputField(
                  'Price',
                  _priceController,
                  TextInputType.number,
                  'Enter price',
                  10,
                  '\$',
                ),
                const SizedBox(height: 20),
                textInputField('Description', _descriptionController,
                    TextInputType.text, 'Enter description', 200),
                ElevatedButton(
                    onPressed: () => pickImage(),
                    child: const Text('Add Image')),
                const SizedBox(height: 20),
                image != null
                    ? Image.file(image!, height: 200, width: 200)
                    : Container(
                        child: Center(child: Text('No Image Selected')),
                      ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showBottomSheet(
                          context: context,
                          builder: (context) => PostConfirm(
                            make: _makeController.text,
                            model: _modelController.text,
                            year: _yearController.text,
                            odometer: _odometerController.text,
                            price: _priceController.text,
                            description: _descriptionController.text,
                            image: File(image!.path),
                          ),
                        );
                      }
                    },
                    child: const Text('Confirm')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
