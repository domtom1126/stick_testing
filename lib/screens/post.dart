import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:find_a_stick/firebase_functions/post_listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../signin_controller.dart';

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
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return buildUserAuth(context);
            } else {
              return buildUserNotAuth(context);
            }
          }),
    );
  }

  Scaffold buildUserNotAuth(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          height: 400,
          width: 300,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'You\'re not logged in!',
                style: TextStyle(color: HexColor('FFFFFF'), fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sign in with your Google account. Intrested people will be able to contact you through your Gmail.',
                  style: TextStyle(color: HexColor('FFFFFF'), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: SignInButton(Buttons.Google,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                }, text: 'Sign in with Google'),
              ),
              SizedBox(
                width: 200,
                child: SignInButton(Buttons.Apple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), onPressed: () {
                  final appleProvider =
                      Provider.of<AppleSignInProvider>(context, listen: false);
                  appleProvider.appleLogin();
                }, text: 'Sign in with Apple'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold buildUserAuth(BuildContext context) {
    bool uploading = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
      ),
      // resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 40),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: <Widget>[
            Text(
              'Manual Cars Only!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _makeController,
              decoration: InputDecoration(
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
              controller: _modelController,
              decoration: InputDecoration(
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
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              keyboardType: TextInputType.number,
              keyboardAppearance: Brightness.dark,
              controller: _yearController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
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
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              controller: _odometerController,
              decoration: InputDecoration(
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
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
                CurrencyTextInputFormatter(symbol: '\$', decimalDigits: 0),
              ],
              controller: _priceController,
              decoration: InputDecoration(
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
              controller: _descriptionController,
              decoration: InputDecoration(
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
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Add Image'),
            ),
            const SizedBox(height: 20),
            pickedImage != null
                ? Image.file(pickedImage!, height: 200, width: 200)
                : const Center(
                    child: Text('Select an image'),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showModalBottomSheet(
                      backgroundColor: HexColor('40434E'),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) => confirmModal(),
                    );
                  }
                },
                child: const Text('Confirm')),
          ],
        ),
      ),
    );
  }

  SizedBox confirmModal() {
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
                image: AssetImage(pickedImage!.path),
                height: 250,
                width: 250,
              ),
            ),
            Row(
              children: [
                Text(
                  _yearController.text,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  ' ${_makeController.text} ${_modelController.text}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Text(_priceController.text),
            Text('${_odometerController.text} Miles'),
            Text(_descriptionController.text),
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
                      final _postListing = PostListing(
                        make: _makeController.text,
                        model: _modelController.text,
                        year: _yearController.text,
                        odometer: _odometerController.text,
                        price: _priceController.text,
                        // TODO Replace with email
                        // email: '',
                        description: _descriptionController.text,
                        image: pickedImage!,
                        dateAdded: DateTime.now().toString(),
                      );
                      await _postListing.addPost(
                        _makeController.text,
                        _modelController.text,
                        _yearController.text,
                        _odometerController.text,
                        _priceController.text,
                        _descriptionController.text,
                        pickedImage!,
                      );
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
