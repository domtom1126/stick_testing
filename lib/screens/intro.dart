import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Column(
        children: [
          Align(
              child: Text(
                'Welcome to Find a Stick',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              alignment: Alignment.center),
          const SizedBox(height: 20),
          Align(
              child: Text(
                'The only app to find manual cars',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              alignment: Alignment.center),
        ],
      ),
    );
  }
}
