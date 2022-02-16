import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
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
            child: Column(
              children: [
                inputField('Make', _makeController, 'Enter make'),
                const SizedBox(height: 20),
                inputField('Model', _modelController, 'Enter model'),
                const SizedBox(height: 20),
                inputField('Year', _yearController, 'Enter year'),
                const SizedBox(height: 20),
                inputField('Odometer', _odometerController, 'Enter odometer'),
                const SizedBox(height: 20),
                inputField('Price', _priceController, 'Enter price'),
                const SizedBox(height: 20),
                inputField(
                    'Description', _descriptionController, 'Enter description'),
                ElevatedButton(
                    onPressed: () => pickImage(),
                    child: const Text('Add Image')),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => showBottomSheet(
                          context: context,
                          builder: (context) => const PostConfirm(),
                        ),
                    child: const Text('Confirm')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
