import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:find_a_stick/firebase_functions/post_listing.dart';
import 'package:find_a_stick/screens/home.dart';
import 'package:find_a_stick/screens/view_car.dart';
import 'package:find_a_stick/widgets/bottom_bar.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';

final TextEditingController _makeController = TextEditingController();
final TextEditingController _modelController = TextEditingController();
final TextEditingController _yearController = TextEditingController();
final TextEditingController _odometerController = TextEditingController();
final TextEditingController _priceController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
final TextEditingController _zipCodeController = TextEditingController();

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // * This is for single image
  File? pickedImage;
  // Future pickImage() async {
  //   final _imagePicker = ImagePicker();
  //   final pickedImage = await _imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //       maxHeight: 200,
  //       maxWidth: 200,
  //       imageQuality: 75);
  //   final imageTemp = File(pickedImage!.path);
  //   setState(() => this.pickedImage = imageTemp);
  // }
  // * This is for multi image
  // List<XFile>? userPickedImages;
  int _currentIndex = 0;
  List<File> pickedImageList = [];
  final imagePicker = ImagePicker();

  Future pickImage() async {
    final userPickedImages = await imagePicker.pickMultiImage();
    for (var image in userPickedImages!) {
      pickedImageList.add(File(image.path));
    }
    setState(() {});
  }

  removeImage() {
    pickedImageList.removeAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return postForm(context);
  }

  Form postForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          MyTextField(
              inputType: TextInputType.text,
              textController: _makeController,
              inputFormatLength: 20,
              inputAction: TextInputAction.next,
              hintText: 'Make'),
          const SizedBox(height: 20),
          MyTextField(
            inputType: TextInputType.text,
            textController: _modelController,
            inputFormatLength: 20,
            inputAction: TextInputAction.next,
            hintText: 'Model',
          ),
          const SizedBox(height: 20),
          yearDropDown(),
          const SizedBox(height: 20),
          MyTextField(
              inputType: TextInputType.number,
              textController: _odometerController,
              inputFormatLength: 10,
              inputAction: TextInputAction.next,
              hintText: 'Odometer'),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
              inputType: TextInputType.number,
              textController: _priceController,
              inputFormatLength: 15,
              inputAction: TextInputAction.next,
              hintText: 'Price'),
          const SizedBox(height: 20),
          MyTextField(
              inputType: TextInputType.number,
              textController: _zipCodeController,
              inputFormatLength: 7,
              inputAction: TextInputAction.next,
              hintText: 'Zip Code (Optional)'),
          const SizedBox(height: 20),
          MyTextField(
            inputType: TextInputType.text,
            textController: _descriptionController,
            inputAction: TextInputAction.next,
            hintText: 'Description',
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          pickedImageList.isEmpty
              ? SizedBox(
                  height: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('23262F'), elevation: 15),
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
                )
              : Column(
                  children: [
                    ElevatedButton(
                        onPressed: pickImage,
                        child: const Text('Add another image')),
                    const SizedBox(
                      height: 10,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        onPageChanged: ((index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        }),
                        // height: 200,
                        viewportFraction: .9,
                        enlargeCenterPage: true,
                      ),
                      items: pickedImageList
                          .map(
                            (item) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: 400,
                                    child: Image.asset(item.path,
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        pickedImageList.removeAt(_currentIndex);
                                      });
                                    },
                                    icon: const Icon(
                                        color: Colors.white,
                                        size: 35,
                                        Icons.delete_forever))
                              ],
                            ),
                            // color: Colors.green,
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          // * Confirm BUtton
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
                      builder: (context) => confirmModal()
                      // AlertDialog(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   backgroundColor: HexColor('333333'),
                      //   title: const Text('Confirm'),
                      //   content: const Text(
                      //       'Please make sure this car is a manual. If it is not it will be deleted.'),
                      //   actions: [
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.of(context).pop();
                      //       },
                      //       child: const Text('Cancel'),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.of(context).pop();
                      //         confirmModal();
                      //         // Navigator.of(context).pop();
                      //       },
                      //       child: const Text('Confirm'),
                      //     ),
                      //   ],
                      // ),
                      );
                }
              },
              child: const Text('Post Car')),
        ],
      ),
    );
  }

  Container yearDropDown() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: HexColor('111111'),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: SizedBox(
        height: 55,
        width: 500,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            alignment: AlignmentDirectional.center,
            hint: const Text('Year'),
            focusColor: HexColor('EE815A'),
            dropdownColor: HexColor('2B2E34'),
            menuMaxHeight: 250,
            value: dropdownValue,
            elevation: 0,
            borderRadius: BorderRadius.circular(25),
            style: TextStyle(
                color: HexColor('FFFFFF'),
                fontWeight: FontWeight.w300,
                fontSize: 16),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView confirmModal() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CarouselSlider(
              options: CarouselOptions(
                onPageChanged: ((index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
                // height: 200,
                viewportFraction: .9,
                enlargeCenterPage: true,
              ),
              items: pickedImageList
                  .map(
                    (item) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 400,
                            child: Image.asset(item.path, fit: BoxFit.fitWidth),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                pickedImageList.removeAt(_currentIndex);
                              });
                            },
                            icon: const Icon(
                                color: Colors.white,
                                size: 35,
                                Icons.delete_forever))
                      ],
                    ),
                    // color: Colors.green,
                  )
                  .toList(),
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
          Text('Zip code: ${_zipCodeController.text} '),
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
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            final _postListing = PostListing(
                              make: _makeController.text,
                              model: _modelController.text,
                              year: dropdownValue,
                              odometer: _odometerController.text,
                              price: _priceController.text,
                              // TODO Replace with email
                              zipCode: _zipCodeController.text,
                              description: _descriptionController.text,
                              images: pickedImageList,
                              dateAdded: DateTime.now().toString(),
                            );

                            await _postListing.addPost(
                              _makeController.text,
                              _modelController.text,
                              dropdownValue,
                              _odometerController.text,
                              _priceController.text,
                              _zipCodeController.text,
                              _descriptionController.text,
                              pickedImageList,
                            );
                            await _postListing
                                .addMake(_makeController.text.toTitleCase());
                            Navigator.pop(context);
                            const CircularProgressIndicator();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomBar()));
                          },
                          child: const Text('Yes')),
                    ),
              // TODO Fix this so there is a loading circle after you post
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Center(child: Text('Edit'))),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField(
      {super.key,
      required this.inputType,
      required this.textController,
      this.inputFormatLength,
      required this.inputAction,
      required this.hintText,
      this.maxLines});
  final TextInputType inputType;
  final TextEditingController textController;
  final int? inputFormatLength;
  final TextInputAction inputAction;
  final String hintText;
  final int? maxLines;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      controller: widget.textController,
      keyboardAppearance: Brightness.dark,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        hintText: widget.hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a make';
        }
        return null;
      },
    );
  }
}
