import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:find_a_stick/firebase_functions/post_listing.dart';
import 'package:find_a_stick/widgets/bottom_bar.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
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
      child: isLoading == true
          ? Center(
              child: SizedBox(
                height: 250,
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Posting your car!')
                  ],
                ),
              ),
            )
          : ListView(
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
                // MyTextField(
                //     inputType: TextInputType.number,
                //     textController: _priceController,
                //     inputFormatters: [
                //       CurrencyTextInputFormatter(
                //           symbol: '\$', decimalDigits: 0),
                //     ],
                //     inputFormatLength: 15,
                //     inputAction: TextInputAction.next,
                //     hintText: 'Price'),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                    // CurrencyTextInputFormatter(symbol: '\$', decimalDigits: 0),
                  ],
                  controller: _priceController,
                  keyboardAppearance: Brightness.dark,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('EE815A'), width: 2.0),
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
                MyTextField(
                    inputType: const TextInputType.numberWithOptions(),
                    textController: _zipCodeController,
                    inputFormatLength: 7,
                    inputAction: TextInputAction.next,
                    hintText: 'Zip Code (Optional)'),
                const SizedBox(height: 20),
                MyTextField(
                  inputType: TextInputType.text,
                  textController: _descriptionController,
                  inputAction: TextInputAction.done,
                  hintText: 'Description',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                pickedImageList.isEmpty ? addImageBox() : showImages(),
                const SizedBox(height: 20),
                // * Confirm BUtton
                postConfirmButton(context),
              ],
            ),
    );
  }

  ElevatedButton postConfirmButton(BuildContext context) {
    return ElevatedButton(
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
                //         // Navigator.of(context).pop();
                //         Navigator.of(context).pushReplacement(confirmModal());
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
        child: const Text('Post Car'));
  }

  Column showImages() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: pickImage,
          child: const Text('Add another image'),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          child: CarouselSlider(
            options: CarouselOptions(
              onPageChanged: ((index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
              // height: 200,
              viewportFraction: 1.0,
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
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child:
                                  Image.asset(item.path, fit: BoxFit.fitWidth)),
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  SizedBox addImageBox() {
    return SizedBox(
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
    );
  }

  Container yearDropDown() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: HexColor('111111'),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: SizedBox(
        height: 60,
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
            borderRadius: BorderRadius.circular(5),
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
                              Icons.delete_forever),
                        )
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
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      Navigator.pop(context);
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

                      // var _priceControllerFormatted = _priceController.text
                      //     .replaceAll(RegExp(r'[^0-9]'), ''); // '23'

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
                      _makeController.clear();
                      _modelController.clear();
                      _yearController.clear();
                      _odometerController.clear();
                      _priceController.clear();
                      _zipCodeController.clear();
                      _descriptionController.clear();
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
      this.inputFormatters,
      required this.inputAction,
      required this.hintText,
      this.maxLines,
      this.keyboardType});
  final TextInputType inputType;
  final TextEditingController textController;
  final int? inputFormatLength;
  final dynamic inputFormatters;
  final TextInputAction inputAction;
  final String hintText;
  final int? maxLines;
  final TextInputType? keyboardType;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType,
      maxLines: widget.maxLines,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
        // CurrencyTextInputFormatter(symbol: '\$', decimalDigits: 0),
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
