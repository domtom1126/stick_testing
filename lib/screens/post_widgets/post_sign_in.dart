import 'package:find_a_stick/screens/post_widgets/post_form.dart';
import 'package:find_a_stick/signin_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class PostSignIn extends StatefulWidget {
  const PostSignIn({Key? key}) : super(key: key);

  @override
  State<PostSignIn> createState() => _PostSignInState();
}

class _PostSignInState extends State<PostSignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return buildSignIn(context);
  }

  Form buildSignIn(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
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
                    if (value == null || value.isEmpty) {
                      return 'Email can\'t be blank';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Enter valid email';
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
                  obscureText: !_passwordVisible,
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
                    suffixIcon: IconButton(
                        icon: Icon(_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        }),
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
                            builder: (context) => const PostForm()),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                      } else if (e.code == 'wrong-password') {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                    backgroundColor: Colors.black45,
                                    title: Text('Privacy Policy'),
                                    content: Text('hello'));
                              });
                        });
                      }
                    }
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
      ),
    );
  }
}

class OrangeLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = HexColor('DF7212')
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(const Offset(200, -125), const Offset(550, 200), paint);

    canvas.drawLine(const Offset(120, -110), const Offset(400, 150), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
