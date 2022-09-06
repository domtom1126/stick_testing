import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../signin_controller.dart';

class EnterZipCode extends StatefulWidget {
  const EnterZipCode({Key? key}) : super(key: key);

  @override
  State<EnterZipCode> createState() => _EnterZipCodeState();
}

class _EnterZipCodeState extends State<EnterZipCode> {
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
                height: 25,
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
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
              const SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: null,
                  child: Text('Sign in / up'),
                ),
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EnterZipCode()));
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
                          primary: Colors.transparent,
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
                        primary: Colors.transparent,
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

    canvas.drawLine(const Offset(120, -75), const Offset(550, 300), paint);

    canvas.drawLine(const Offset(120, 0), const Offset(400, 250), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
