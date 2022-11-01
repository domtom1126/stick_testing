import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_a_stick/screens/post_widgets/post_form.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// class Search extends SearchDelegate {
//   List<String> searchResults = [
//     'Ford',
//     'Chevy',
//     'Bubba',
//   ];
//   @override
//   PreferredSizeWidget? buildBottom(BuildContext context) {
//     return const PreferredSize(
//       preferredSize: Size.fromHeight(20),
//       child: Text('Search make or model'),
//     );
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     final ColorScheme colorScheme = theme.colorScheme;
//     return theme.copyWith(
//       appBarTheme: AppBarTheme(
//         backgroundColor: Colors.transparent,
//         iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
//       ),
//       inputDecorationTheme: searchFieldDecorationTheme ??
//           InputDecorationTheme(
//             hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
//             border: InputBorder.none,
//           ),
//     );
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Center(
//       child: Text(query),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // firebase instance
//     final cars = FirebaseFirestore.instance
//         .collection('makes')
//         .orderBy('date_added', descending: true)
//         .snapshots()
//         .toList;
//     List<String> suggestions = searchResults.where((searchResult) {
//       final result = searchResult.toLowerCase();
//       final input = query.toLowerCase();
//       return result.contains(input);
//     }).toList();
//     return ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (context, index) {
//           final suggestion = suggestions[index];
//           return ListTile(
//             title: Text(suggestion),
//             onTap: () {
//               query = suggestion;
//               showResults(context);
//             },
//           );
//         });
//   }
// }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool light = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _zipCodeController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Search Cars')),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Form(
            key: _formKey,
            child: Column(children: [
              // Reset all button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // Reset text controllers
                  },
                  child: Text(
                    'Reset all',
                    style: TextStyle(color: HexColor('DF7212'), fontSize: 16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Have an option to use current location
                  const Text('Use my location'),
                  Switch(
                    // This bool value toggles the switch.
                    value: light,
                    activeColor: HexColor('DF7212'),
                    onChanged: (bool value) {
                      // Ask for user location

                      // If user denies location and selects again showDialog for location settings
                      setState(() {
                        light = value;
                      });
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Radius dropdown
                  // TODO Fix the padding on text to go more left
                  const SizedBox(width: 150, child: SearchRadiusDropdown()),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: _zipCodeController,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor('EE815A'), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Zip Code',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Make',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_circle_right_sharp,
                        color: HexColor('DF7212'),
                      )
                    ],
                  ),
                  onPressed: () {
                    // * On make selection go to scrollview
                    //* Scroll view needs to generate from a list of models from firebase
                    // TODO Make sure that we are adding models to firebase list
                    // * On selection we need to navigate back to search page
                    // * Ungrey out the model selector
                    // * Replace the 'make' text with whatever make user selects
                  },
                ),
              ),
              const Divider(
                color: Colors.white,
              ),

              // New or used option

              // Enter make
              // Enter model
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Model',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_circle_right_sharp,
                        color: HexColor('DF7212'),
                      )
                    ],
                  ),
                  onPressed: () {
                    // * This will be the same as make
                    // TODO Make firebase upload models connected with each make
                  },
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              // Max price

              // Search button with amount of lisings within those search terms
              //
            ]),
          ),
        ),
      ),
    );
  }
}

List<String> _radiusList = [
  '10',
  '20',
  '30',
  '40',
  '50',
  '75',
  '100',
  '150',
  '200',
  '250',
  '500',
  '750',
  '1000',
  'Unlimited',
];
String _dropdownValue = _radiusList.first;

class SearchRadiusDropdown extends StatefulWidget {
  const SearchRadiusDropdown({super.key});

  @override
  State<SearchRadiusDropdown> createState() => _SearchRadiusDropdownState();
}

class _SearchRadiusDropdownState extends State<SearchRadiusDropdown> {
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
        width: 150,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            alignment: AlignmentDirectional.center,
            hint: const Text('Year'),
            focusColor: HexColor('EE815A'),
            dropdownColor: HexColor('2B2E34'),
            menuMaxHeight: 250,
            value: _dropdownValue,
            elevation: 0,
            borderRadius: BorderRadius.circular(25),
            style: TextStyle(
                color: HexColor('FFFFFF'),
                fontWeight: FontWeight.w300,
                fontSize: 16),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _dropdownValue = value!;
              });
            },
            items: _radiusList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('$value miles'),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
