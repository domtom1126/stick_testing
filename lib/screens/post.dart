import 'package:flutter/material.dart';
import 'package:testing/widgets/form_widgets/form_widgets.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Container(
          child: formWidget(),
        ),
      ),
    );
  }
}
