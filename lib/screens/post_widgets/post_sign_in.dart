import 'package:find_a_stick/signin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class PostSignIn extends StatefulWidget {
  const PostSignIn({Key? key}) : super(key: key);

  @override
  State<PostSignIn> createState() => _PostSignInState();
}

class _PostSignInState extends State<PostSignIn> {
  @override
  Widget build(BuildContext context) {
    return buildSignIn(context);
  }

  Center buildSignIn(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: HexColor('EE6C4D'), width: 1),
        ),
        height: 400,
        width: 300,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              'You\'re not logged in!',
              style: TextStyle(color: HexColor('FFFFFF'), fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sign in below with Google. \n You\'ll be able to post after you sign in.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey[800],
              height: 50,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SignInButton(Buttons.Google,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SignInButton(Buttons.Apple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), onPressed: () {
                final appleProvider =
                    Provider.of<AppleSignInProvider>(context, listen: false);
                appleProvider.appleLogin();
              }, text: 'Sign in with Apple'),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 35,
              width: 220,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () {
                      // show dialog
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text('Coming Soon!'),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: HexColor('40434E'),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            context: context,
                                            builder: (BuildContext context) =>
                                                signUpModal(context));
                                      },
                                      child: const Text('Sign Up'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // show bottommodal
                                        showModalBottomSheet(
                                            backgroundColor: HexColor('40434E'),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            context: context,
                                            builder: (BuildContext context) {
                                              return signInModal(context);
                                            });
                                      },
                                      child: const Text('Sign In'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Text('Sign in with email')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView signInModal(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Sign In',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sign In'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  SingleChildScrollView signUpModal(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Sign In',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last Name',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}
