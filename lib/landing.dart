import 'package:flutter/material.dart';
import './common/loader.dart';
import './global_bloc.dart';
import './state_provider.dart';
import './user_model.dart';
import './views/auth/name_email.dart';
import './views/home/home_view.dart';
import './common/conditional_builder.dart';
import './common/loader.dart';

class LandingControl extends  StatelessWidget{
  @override
  Widget build(BuildContext context) {
   
   return StreamBuilder<User>(
     stream:Provider.of<GlobalBloc>(context).user,
     builder: (_,AsyncSnapshot<User> user){
       return ConditionalBuilder(
         condition: user.data?.displayName==null,
         trueBuilder: Scaffold(body: NameEmailScreen()),
         falseBuilder: HomeViewContainer(),
       );
     },
   );
  }
}
