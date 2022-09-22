import 'package:find_a_stick/screens/profile.dart';
import 'package:find_a_stick/screens/profile_widgets/profile_screen.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../widgets/global_widgets.dart';

class ProfileSignIn extends StatefulWidget {
  const ProfileSignIn({Key? key}) : super(key: key);

  @override
  State<ProfileSignIn> createState() => _ProfileSignInState();
}

class _ProfileSignInState extends State<ProfileSignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return buildSignIn(context);
  }

  Widget buildSignIn(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: OrangeLines(),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              'Log in to view profile',
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
                  final emailRegex = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (value!.isEmpty || !emailRegex.hasMatch(value)) {
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
                  final passwordRegex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  // TODO put proper validation for password
                  if (value!.isEmpty || !passwordRegex.hasMatch(value)) {
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

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                  // TODO Update to the signed in page
                },
                child: const Text('Sign in / up'),
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
      ..color = HexColor('EE6C4D')
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(200, -125), const Offset(550, 200), paint);

    canvas.drawLine(const Offset(120, -110), const Offset(400, 150), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
