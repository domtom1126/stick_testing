import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          const SizedBox(height: 10),
          Align(
              child: Text(
                'The only app to find manual cars',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              alignment: Alignment.center),
          const SizedBox(height: 30),
          // Show expansion panel
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                  title: Text(
                    'Getting Started',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  children: const [
                    Text(
                      '1. Sign in\n\n2. Post a car\n\n3. Like a car\n\n4.Email the owner\n\n5. Get to shiftin those gears!',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                ExpansionTile(
                  title: Text('Get involved!',
                      style: Theme.of(context).textTheme.bodyLarge),
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'All source code is available on ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: 'GitHub',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 20),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    'https://github.com/domtom1126/stick_testing');
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // button on bottom of screen
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
