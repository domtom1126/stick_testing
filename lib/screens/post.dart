import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../signin_controller.dart';
import '../widgets/form_widgets/form_widgets.dart';

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

  final controller = Get.put(LoginController());
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  @override
  // void initState() {
  //   super.initState();
  //   _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
  //     setState(() {
  //       _currentUser = account;
  //     });
  //     if (_currentUser != null) {
  //       buildUserAuth(context);
  //     }
  //   });
  //   _googleSignIn.signInSilently();
  // }

  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.googleAccount.value == null) {
        return buildUserNotAuth(context);
      } else {
        return buildUserAuth(context);
      }
    });
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
                'You\'re not logged in',
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
                child: SignInButton(Buttons.Google, onPressed: () {
                  controller.googleLogin();
                }, text: 'Sign in with Google'),
              ),
              SizedBox(
                width: 200,
                child: SignInButton(Buttons.Apple, onPressed: () {
                  controller.appleLogin();
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(
                'Manual Cars Only!',
                style: TextStyle(fontSize: 20, color: HexColor('FFFFFF')),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
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
                keyboardAppearance: Brightness.dark,
                controller: _yearController,
                style: TextStyle(color: HexColor('FFFFFF')),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: HexColor('FFFFFF')),
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
                  onPressed: pickImage, child: const Text('Add Image')),
              const SizedBox(height: 20),
              pickedImage != null
                  ? Image.file(pickedImage!, height: 200, width: 200)
                  : const Center(child: Text('Select an image')),
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
                          email: controller.googleAccount.value!.email,
                          description: _descriptionController.text,
                          image: pickedImage!,
                        ),
                      );
                    }
                  },
                  child: const Text('Confirm')),
            ],
          ),
        ),
      ),
    );
  }
}
