import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:find_a_stick/firebase_functions/post_listing.dart';
import 'package:find_a_stick/widgets/bottom_bar.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              backgroundColor: Colors.transparent,
              floating: true,
              pinned: false,
              snap: false,
              title: Text(
                'Post Car',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ];
        },
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
                return buildSignIn(context);
              }
            }),
      ),
    );
  }

  Center buildSignIn(BuildContext context) {
    return Center(
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
              height: 25,
            ),
            Text(
              'You\'re not logged in!',
              style: TextStyle(color: HexColor('FFFFFF'), fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sign in below with Google. \n You\'ll be able to post after you sign in.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              height: 50,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SignInButton(Buttons.Google,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
    );
  }

  Form buildUserAuth(BuildContext context) {
    // TODO add loading circle when user posts
    bool uploading = false;
    // resizeToAvoidBottomInset: false,
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Text('Manual vehicles only',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center),
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
            textInputAction: TextInputAction.next,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              CurrencyTextInputFormatter(symbol: '\$', decimalDigits: 0),
            ],
            controller: _priceController,
            keyboardAppearance: Brightness.dark,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
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
            textInputAction: TextInputAction.done,
            controller: _descriptionController,
            keyboardAppearance: Brightness.dark,
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
          pickedImage != null
              ? Column(
                  children: [
                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text('Add Another Image'),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            Image.file(pickedImage!, height: 200, width: 200)),
                  ],
                )
              : SizedBox(
                  height: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor('23262F'), elevation: 15),
                    onPressed: pickImage,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 65,
                        ),
                        Icon(
                          Icons.add_circle_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Add Image'),
                      ],
                    ),
                  ),
                ),
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
                  showModalBottomSheet(
                    isScrollControlled: true,
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
    );
  }

  SingleChildScrollView confirmModal() {
    bool isLoading = false;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              pickedImage!.path,
              fit: BoxFit.fitWidth,
            ),
          ),
          Row(
            children: [
              Text(
                '${_yearController.text} ${_makeController.text} ${_modelController.text}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            _priceController.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '${_odometerController.text} Miles',
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
            '${_descriptionController.text} ',
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
          const Center(
            child: Text('Are you sure you want to post this car?'),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final _postListing = PostListing(
                        make: _makeController.text,
                        model: _modelController.text,
                        year: _yearController.text,
                        odometer: _odometerController.text,
                        price: _priceController.text,
                        // TODO Replace with email
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
                      await _postListing
                          .addMake(_makeController.text.toTitleCase());
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (_) => false);
                    },
                    child: const Text('Yes')),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Center(child: Text('Edit'))),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
