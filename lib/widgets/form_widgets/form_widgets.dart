import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/firebase_functions/post_listing.dart';
import 'package:testing/listing_bloc.dart';
import 'package:testing/screens/post.dart';

TextEditingController _makeController = TextEditingController();
TextEditingController _modelController = TextEditingController();
TextEditingController _yearController = TextEditingController();
TextEditingController _odometerController = TextEditingController();
TextEditingController _priceController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();

Widget inputField(
    String label, TextEditingController controller, String errorMessage) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: label,
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        print(value);
        return errorMessage;
      }
      return null;
    },
  );
}

Future addCar() async {
  Column(children: <Widget>[
    inputField('Make', _makeController, 'Please enter a make'),
    inputField('Model', _modelController, 'Please enter a model'),
    inputField('Year', _yearController, 'Please enter a year'),
    inputField('Odometer', _odometerController, 'Please enter an odometer'),
    inputField('Price', _priceController, 'Please enter a price'),
    inputField(
        'Description', _descriptionController, 'Please enter a description'),
  ]);
}

Future pickImage() async {
  final _imagePicker = ImagePicker();
  final image = await _imagePicker.pickImage(source: ImageSource.gallery);
}

// _postingBloc.add(PostingEvent.postingSuccess());
class PostConfirm extends StatefulWidget {
  const PostConfirm({Key? key}) : super(key: key);

  @override
  _PostConfirmState createState() => _PostConfirmState();
}

class _PostConfirmState extends State<PostConfirm> {
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
            const Placeholder(
              fallbackHeight: 250,
              fallbackWidth: 300,
            ),
            Row(
              children: [
                Text(
                  _yearController.text,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  ' ${_makeController.text}${_modelController.text}',
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
                ElevatedButton(
                    onPressed: () => addCar(), child: const Text('Yes')),
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text('No')),
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
