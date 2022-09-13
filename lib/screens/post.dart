import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:find_a_stick/firebase_functions/post_listing.dart';
import 'package:find_a_stick/screens/profile_widgets/profile_sign_in.dart';
import 'package:find_a_stick/widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../signin_controller.dart';
import 'post_widgets/post_form.dart';
import 'post_widgets/post_sign_in.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            PostAppBar(),
          ];
        },
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return const PostForm();
              } else {
                return const PostSignIn();
              }
            }),
      ),
    );
  }
}

class PostAppBar extends StatelessWidget {
  const PostAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      floating: true,
      pinned: false,
      snap: false,
      title: Text(
        'Post Car',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
