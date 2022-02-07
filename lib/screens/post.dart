import 'package:flutter/cupertino.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Container(
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(children: [
              makeInput(),
              modelInput(),
              yearInput(),
              odometerInput(),
              priceInput(),
              descriptionInput(),
              ElevatedButton(
                  onPressed: () => confirmModal(),
                  child: const Text('Confirm')),
            ]),
          ),
        ),
      ),
    );
  }

  // TODO this stuff needs to be bloc
  Future<void> confirmModal() async {
    setState(
      () {
        showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Are you sure you want to add this car?',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context);
                          addCar();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Bloc Stuff

// BlocProvider(
//         create: (BuildContext context) => PostingBloc(),
//         child: formWidget(),
//       ),
