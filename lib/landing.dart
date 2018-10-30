import 'package:flutter/material.dart';
import './common/loader.dart';
import './global_bloc.dart';
import './state_provider.dart';
import './user_model.dart';
class LandingControl extends StatefulWidget {
  final User user;

  const LandingControl({Key key,@required this.user}) : super(key: key);
  @override
  _LandingControlState createState() => new _LandingControlState();
}

class _LandingControlState extends State<LandingControl> {
  
  @override
  void initState() {
    if(widget.user.isNew){
      Navigator.pushNamed(context, '/name-email');
    }
    else{
      Navigator.pushNamed(context, '/home');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loader();
  }
}
