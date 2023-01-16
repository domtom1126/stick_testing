import 'package:find_a_stick/widgets/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../signin_controller.dart';

/* 
1. Page view with screen
*/
class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loginFail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: CustomPaint(
            painter: OrangeLines(),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [HexColor('618094'), HexColor('DF7212')])),
              child: Column(
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                  SizedBox(
                    height: 170,
                    child: Image.asset(
                        '/Users/dominic./dev/stick_testing/images/appstore_logo.png'),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Find a Stick',
                    style: TextStyle(color: HexColor('FFFFFF'), fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
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
                    height: 25,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                      validator: (value) =>
                          value != null && value.isEmpty ? 'Enter email' : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      obscureText: true,
                      autocorrect: false,
                      // keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
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
                      validator: (value) => value != null && value.isEmpty
                          ? 'Enter password'
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      // TODO validation for email and password
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomBar()),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            // TODO Add validation
                            if (e.code == 'wrong-password') {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Text('Hello');
                                    });
                              });
                            }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomBar()));
                          }
                        }
                      },
                      child: const Text('Sign in / up'),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('showHome', true);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomBar()));
                      },
                      child: const Text('Skip this step'),
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
                                image: AssetImage(
                                    'graphics/icons8-google-48.png')),
                            onPressed: () async {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              await provider.googleLogin();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomBar()));
                            }),
                      ),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            final appleProvider =
                                Provider.of<AppleSignInProvider>(context,
                                    listen: false);
                            appleProvider.appleLogin();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomBar()));
                          },
                          child: const Image(
                            image:
                                AssetImage('graphics/icons8-apple-logo-50.png'),
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
          ),
        ));
  }
}

class OrangeLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = HexColor('DF7212')
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(120, -75), const Offset(550, 300), paint);

    canvas.drawLine(const Offset(120, 0), const Offset(400, 250), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
