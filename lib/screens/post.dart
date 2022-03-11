import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

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
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text('Post'),
          )
        ],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                textInputField('Make', _makeController, TextInputType.text,
                    'Enter make', 20, 1),
                const SizedBox(height: 20),
                textInputField('Model', _modelController, TextInputType.text,
                    'Enter model', 20, 1),
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
                    TextInputType.text, 'Enter description', 200, 5),
                ElevatedButton(
                    onPressed: () async {
                      final _imagePicker = ImagePicker();
                      final pickedImage = await _imagePicker.pickImage(
                          source: ImageSource.gallery);
                      final imageTemp = File(pickedImage!.path);
                      setState(() => this.pickedImage = imageTemp);
                    },
                    child: const Text('Add Image')),
                const SizedBox(height: 20),
                pickedImage != null
                    ? Image.file(pickedImage!, height: 200, width: 200)
                    : Center(child: Text('Select an image')),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (context) => PostConfirm(
                            make: _makeController.text,
                            model: _modelController.text,
                            year: _yearController.text,
                            odometer: _odometerController.text,
                            price: _priceController.text,
                            description: _descriptionController.text,
                            // image: '',
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
