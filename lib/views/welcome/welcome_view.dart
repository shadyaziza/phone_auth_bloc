import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    _delay();
    super.initState();
  }
Future<void> _delay()async{
  await Future.delayed(Duration(seconds: 3));
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/landing', (Route r) => r == null);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Welcome Screen')),
    );
  }
}
