import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './views/auth/auth_view_container.dart';
import './global_bloc.dart';
import './state_provider.dart';
import './user_model.dart';
import './common/conditional_builder.dart';
import './common/loader.dart';
import './landing.dart';
import './views/auth/name_email.dart';
import './views/home/home_view.dart';
import './views/welcome/welcome_view.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalBloc bloc = Provider.of<GlobalBloc>(context);
    return MaterialApp(
      routes: {
        '/name-email':(_)=>NameEmailScreen(),
        '/welcome':(_)=>NameEmailScreen(),
        '/home':(_)=>NameEmailScreen(),
      },
      theme: ThemeData.dark(),
      home: StreamBuilder<bool>(
        stream: bloc.loading,
        initialData: true,
        builder: (_,AsyncSnapshot<bool> loading){
          // FirebaseAuth.instance.signOut();
          return ConditionalBuilder(
            condition:loading?.data,
            trueBuilder:Loader(),
            falseBuilder: StreamBuilder(
              stream: bloc.user,
              builder: (_,AsyncSnapshot<User> user){
                return ConditionalBuilder(
                  condition: user.hasData,
                  trueBuilder: LandingControl(
                    user: user.data,
                  ),
                  falseBuilder: AuthViewContainer(),
                );
              },
            ),

          );
        },
      )
    );
  }
}