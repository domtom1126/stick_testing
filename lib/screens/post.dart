import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            Text('Make'),
            TextFormField(),
            Text('Model'),
            TextFormField(),
            Text('Year'),
            TextFormField(),
            Text('Odometer'),
            TextFormField(),
          ],
        ),
      ),
    );
  }
}
