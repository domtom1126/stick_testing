import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../signin_controller.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: OrangeLines(),
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Text(
                'Find a Stick',
                style: TextStyle(color: HexColor('FFFFFF'), fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Text(
                  'The only app to find manual transmission vehicles',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                controller: _emailController,
                keyboardAppearance: Brightness.dark,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: HexColor('EE815A'), width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
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
                                              backgroundColor:
                                                  HexColor('40434E'),
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                              backgroundColor:
                                                  HexColor('40434E'),
                                              shape:
                                                  const RoundedRectangleBorder(
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

class OrangeLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = const Offset(100, 0);
    Offset endPoint = Offset(size.width, 150);

    canvas.drawLine(startingPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
