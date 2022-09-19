import 'package:find_a_stick/signin_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../widgets/global_widgets.dart';

class PostSignIn extends StatefulWidget {
  const PostSignIn({Key? key}) : super(key: key);

  @override
  State<PostSignIn> createState() => _PostSignInState();
}

class _PostSignInState extends State<PostSignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return buildSignIn(context);
  }

  Center buildSignIn(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: OrangeLines(),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              'Log in to post',
              style: TextStyle(color: HexColor('FFFFFF'), fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
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
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                controller: _passwordController,
                keyboardAppearance: Brightness.dark,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: HexColor('EE815A'), width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  hintText: 'Password',
                ),
                validator: (value) {
                  // TODO put proper validation for password
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  signInUp(
                    _emailController.toString(),
                    _passwordController.toString(),
                  );
                  // TODO Update to the signed in page
                },
                child: Text('Sign in / up'),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Image(
                          image: AssetImage('graphics/icons8-google-48.png')),
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin();
                      }),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      final appleProvider = Provider.of<AppleSignInProvider>(
                          context,
                          listen: false);
                      appleProvider.appleLogin();
                    },
                    child: const Image(
                      image: AssetImage('graphics/icons8-apple-logo-50.png'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class OrangeLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = HexColor('EE6C4D')
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(200, -125), const Offset(550, 200), paint);

    canvas.drawLine(const Offset(120, -110), const Offset(400, 150), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
