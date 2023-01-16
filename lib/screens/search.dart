import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   bool light = false;

//   final TextEditingController _zipCodeController = TextEditingController();
//   // @override
//   // void dispose() {
//   //   _zipCodeController.dispose();
//   //   super.dispose();
//   // }
//   double currentSliderValue = 0;
//   final double _status = 0;

//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Search Cars')),
//       body: Center(
//         child: SizedBox(
//           width: 350,
//           child: ListView(
//             physics: const NeverScrollableScrollPhysics(),
//             // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
//             children: [
//               Form(
//                 key: _formKey,
//                 child: Column(children: [
//                   // Reset all button
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: TextButton(
//                       onPressed: () {
//                         // Reset text controllers
//                       },
//                       child: Text(
//                         'Reset all',
//                         style:
//                             TextStyle(color: HexColor('DF7212'), fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Have an option to use current location
//                       const Text('Use my location'),
//                       Switch(
//                         // This bool value toggles the switch.
//                         value: light,
//                         activeColor: HexColor('DF7212'),
//                         onChanged: (bool value) {
//                           // Ask for user location

//                           // If user denies location and selects again showDialog for location settings
//                           setState(() {
//                             light = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Radius dropdown
//                       // TODO Fix the padding on text to go more left
//                       const SizedBox(width: 150, child: SearchRadiusDropdown()),
//                       SizedBox(
//                         width: 150,
//                         child: TextFormField(
//                           textInputAction: TextInputAction.done,
//                           controller: _zipCodeController,
//                           keyboardType: TextInputType.number,
//                           keyboardAppearance: Brightness.dark,
//                           decoration: InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: HexColor('EE815A'), width: 2.0),
//                               borderRadius: BorderRadius.circular(25.0),
//                             ),
//                             hintText: 'Zip Code',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextButton(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Make',
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                           Icon(
//                             Icons.arrow_circle_right_sharp,
//                             color: HexColor('DF7212'),
//                           )
//                         ],
//                       ),
//                       onPressed: () {
//                         // * On make selection go to scrollview
//                         //* Scroll view needs to generate from a list of models from firebase
//                         // TODO Make sure that we are adding models to firebase list
//                         // * On selection we need to navigate back to search page
//                         // * Ungrey out the model selector
//                         // * Replace the 'make' text with whatever make user selects
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SelectMake(),
//                             ));
//                       },
//                     ),
//                   ),
//                   const Divider(
//                     color: Colors.white,
//                   ),

//                   // New or used option

//                   // Enter make
//                   // Enter model
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextButton(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Model',
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                           Icon(
//                             Icons.arrow_circle_right_sharp,
//                             color: HexColor('DF7212'),
//                           )
//                         ],
//                       ),
//                       onPressed: () {
//                         // * This will be the same as make
//                         // TODO Make firebase upload models connected with each make
//                       },
//                     ),
//                   ),
//                   const Divider(
//                     color: Colors.white,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   // Max price
//                   // * Ideally I want the slider values to update with the make and model selection.
//                   // * This is just simply grabbing the max and min prices of the cars with the same make and model
//                   const Text(
//                     'What\'s your price range?',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   // SizedBox(
//                   //   width: 325,
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: const [Text('\$0'), Text('\$500,000 +')],
//                   //   ),
//                   // ),
//                   Slider.adaptive(
//                     value: currentSliderValue,
//                     min: 0,
//                     max: 100,
//                     divisions: 5,
//                     // * Label not working
//                     // label: "\${$currentSliderValue}",
//                     onChanged: (double value) {
//                       setState(() {
//                         currentSliderValue = value;
//                         // print(value);
//                       });
//                     },
//                     onChangeStart: (value) {
//                       setState(() {
//                         currentSliderValue = _status;
//                       });
//                     },
//                     onChangeEnd: (value) {
//                       setState(() {});
//                     },
//                   ),
//                   Text('Status: $_status'),
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   // Search button with amount of lisings within those search terms
//                   ElevatedButton(
//                       onPressed: () {}, child: const Text('Search cars'))
//                   //
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _zipCodeController.dispose();
//   }
// }

// List<String> _radiusList = [
//   '10',
//   '20',
//   '30',
//   '40',
//   '50',
//   '100',
//   '250',
//   '500',
//   '1000',
//   'Unlimited',
// ];
// String _dropdownValue = _radiusList.first;

// class SearchRadiusDropdown extends StatefulWidget {
//   const SearchRadiusDropdown({super.key});

//   @override
//   State<SearchRadiusDropdown> createState() => _SearchRadiusDropdownState();
// }

// class _SearchRadiusDropdownState extends State<SearchRadiusDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(
//             color: HexColor('111111'),
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(25))),
//       child: SizedBox(
//         height: 55,
//         width: 150,
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             alignment: AlignmentDirectional.center,
//             hint: const Text('Year'),
//             focusColor: HexColor('EE815A'),
//             dropdownColor: HexColor('2B2E34'),
//             menuMaxHeight: 250,
//             value: _dropdownValue,
//             elevation: 0,
//             borderRadius: BorderRadius.circular(25),
//             style: TextStyle(
//                 color: HexColor('FFFFFF'),
//                 fontWeight: FontWeight.w300,
//                 fontSize: 16),
//             onChanged: (String? value) {
//               // This is called when the user selects an item.
//               setState(() {
//                 _dropdownValue = value!;
//               });
//             },
//             items: _radiusList.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text('$value miles'),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
// * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ * //
// * THIS IS A BASIC SEARCH NOTHING MORE THAN A SEARCH BAR FOR MAKE, MODEL AND YEAR * //
// * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ * //

// class SearchCars extends StatefulWidget {
//   const SearchCars({super.key});

//   @override
//   State<SearchCars> createState() => _SearchCarsState();
// }

// class _SearchCarsState extends State<SearchCars> {
//   Future<QuerySnapshot>? postDocumentList;
//   String carSearchText = '';

//   initSearchingCars(String textEntered) {
//     postDocumentList = FirebaseFirestore.instance
//         .collection('makes')
//         .orderBy('name', descending: true)
//         .get();

//     setState(() {
//       postDocumentList;
//     });
//     initSearchingCars(textEntered);
//   }

//   TextEditingController _searchController = TextEditingController();
//   String _searchText = '';
//   List _searchResults = [];

//   @override
//   Widget build(BuildContext context) {
//     QuerySnapshot snapshot;
//     return Scaffold(
//         appBar: AppBar(
//           title: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 hintText: "Search...",
//               ),
//               onChanged: (value) {
//                 search();
//               }),
//         ),
//         body: Container());
//   }

//   void search() async {
//     String query = _searchController.text;
//     CollectionReference collection =
//         FirebaseFirestore.instance.collection('makes');
//     QuerySnapshot snapshot =
//         await collection.where('field', isEqualTo: query).get();

//     // Output the search results
//     snapshot.docs.forEach((document) {
//       print(document.data);
//     });
//   }
// }

// * ChatGPT liveserach question

class LiveSearch extends StatefulWidget {
  @override
  _LiveSearchState createState() => _LiveSearchState();
}

class _LiveSearchState extends State<LiveSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamQuery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                  streamQuery = FirebaseFirestore.instance
                      .collection("makes")
                      .where("make", isGreaterThanOrEqualTo: _searchText)
                      .where('make', isLessThan: _searchText + 'z')
                      .snapshots();
                });
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: streamQuery,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Search Make, model or year'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]["make"]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
