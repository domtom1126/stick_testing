import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in/Sign up',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'If you don\'t have an account you can sign up here too',
                    style: TextStyle(fontSize: 15),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  'Forgot Password',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () => _signInSignUp(
                        _emailController.text, _passwordController.text),
                  )),
            ],
          )),
    );
  }

  void _signInSignUp(String email, String password) async {
    try {
      Navigator.pop(context);
      CollectionReference addNewUser =
          FirebaseFirestore.instance.collection('users');
      await addNewUser.add({
        'email': email,
        'password': password,
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          Text('The password provided is too weak.');
        });
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      }
    } catch (e) {
      print(e);
    }
  }
}

class SignInModal extends StatefulWidget {
  const SignInModal({Key? key}) : super(key: key);

  @override
  _SignInModalState createState() => _SignInModalState();
}

class _SignInModalState extends State<SignInModal> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loginFail = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in/Sign up',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'If you don\'t have an account you can sign up here too',
                    style: TextStyle(fontSize: 15),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: loginFail ? 'Password is not correct' : null,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO add forgot password screen
                },
                child: const Text(
                  'Forgot Password',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () => _signInSignUp(
                        _emailController.text, _passwordController.text),
                  )),
            ],
          )),
    );
  }

  void _signInSignUp(String email, String password) async {
    try {
      // Navigator.pop(context);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          Text('The password provided is too weak.');
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          loginFail = true;
        });
      } else if (e.code == 'email-already-in-use') {
        // Navigator.pop(context);
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      }
    } catch (e) {
      print(e);
    }
  }
}
