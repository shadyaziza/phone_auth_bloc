import 'package:flutter/material.dart';
import './common/loader.dart';
import './global_bloc.dart';
import './state_provider.dart';
import './user_model.dart';
import './views/auth/name_email.dart';
import './views/home/home_view.dart';
class LandingControl extends StatefulWidget {
  final User user;

  const LandingControl({Key key,@required this.user}) : super(key: key);
  @override
  _LandingControlState createState() => new _LandingControlState();
}

class _LandingControlState extends State<LandingControl> {
  
  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     if(widget.user.isNew){
     return Scaffold(body: NameEmailScreen()); 
    }
    else{
     return HomeViewContainer();
    }
  }
}
