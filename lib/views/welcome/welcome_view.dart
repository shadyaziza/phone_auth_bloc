import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
    void initState() {
      Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushNamed('/home');
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:Center(
         child:Text('Welcome Screen')
       ),
    );
  }
}