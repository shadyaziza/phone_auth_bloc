import 'package:flutter/material.dart';
import '../../global_bloc.dart';
import '../../state_provider.dart';
import '../../user_model.dart';

class HomeViewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc bloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
        body: StreamBuilder(
            stream: bloc.user,
            builder: (_, AsyncSnapshot<User> user) {
              return Column(children: [
                Text(user.data.uid),
                Text(user.data.displayName),
                Text(user.data.email),

                RaisedButton(
                  child:Text('Sign Out'),
                  onPressed:(){}
                )
              ]);
            }));
  }
}
