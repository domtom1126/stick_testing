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
            // height: 400,
            // decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.grey,
            //     ),
            //     borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(children: [
              makeInput(),
              const SizedBox(height: 20),
              modelInput(),
              const SizedBox(height: 20),
              yearInput(),
              const SizedBox(height: 20),
              odometerInput(),
              const SizedBox(height: 20),
              priceInput(),
              const SizedBox(height: 20),
              descriptionInput(),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => showBottomSheet(
                        context: context,
                        builder: (context) => postConfirm(),
                      ),
                  child: const Text('Confirm')),
            ]),
          ),
        ),
      ),
    );
  }
}
