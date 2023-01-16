import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

// TODO Change these print calls

// signInUp(String email, String password) async {
//   try {
//     await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'weak-password') {
//       print('The password provided is too weak.');
//     } else if (e.code == 'email-already-in-use') {
//       try {
//         FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'wrong-password') {
//           print('wrong password');
//         }
//       }
//     }
//   } catch (e) {
//     print(e);
//   }
// }

Iterable<String> list =
    List<String>.generate(2024 - 1900, (i) => (1900 + i).toString()).reversed;
String dropdownValue = list.first;

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  // decoration: InputDecoration(
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: HexColor('EE815A'), width: 2.0),
  //               borderRadius: BorderRadius.circular(25.0),
  //             ),
  //             hintText: 'Model',
  //           ),

  @override
  Widget build(BuildContext context) {
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
}
