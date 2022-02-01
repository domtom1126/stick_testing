import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/listing_bloc.dart';
import 'package:testing/widgets/form_widgets/form_widgets.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Car'),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          makeInput(),
          modelInput(),
          yearInput(),
          odometerInput(),
          priceInput(),
          addCarButton(),
          ElevatedButton(
              onPressed: () => confirmModal(), child: Text('Confirm')),
        ]),
      ),
    );
  }

  Future<void> confirmModal() async {
    setState(() {
      showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure you want to add this car?',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context);
                          addCar();
                        },
                      ),
                      ElevatedButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
    });
  }
}

// class PostScreen extends StatelessWidget {
//   const PostScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _postingBloc = BlocProvider.of<PostingBloc>(context);
//     return Container(
//       child: ElevatedButton(
//         onPressed: () {
//           // _postingBloc.add(_postingBloc.postingState());
//         },
//         child: Text('Add Car'),
//       ),
//     );
//   }
// }


// Bloc Stuff 

// BlocProvider(
//         create: (BuildContext context) => PostingBloc(),
//         child: formWidget(),
//       ),