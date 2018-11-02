import 'package:flutter/material.dart';
import '../../global_bloc.dart';
import '../../state_provider.dart';
import '../../models/user_model.dart';
import '../../error_handler.dart';

class HomeViewContainer extends StatefulWidget {
  @override
  HomeViewContainerState createState() {
    return new HomeViewContainerState();
  }
}

class HomeViewContainerState extends State<HomeViewContainer> implements ErrorHandler {
  List _dates = List.generate(5, (int index)=>DateTime.now().add(Duration(days: index)));
  @override
  Widget build(BuildContext context) {

    final GlobalBloc bloc = Provider.of<GlobalBloc>(context);
 
    return Scaffold(
        body: StreamBuilder(
            stream: bloc.user,
            builder: (_, AsyncSnapshot<User> user) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text(user.data?.uid??''),
                Text(user.data?.displayName??''),
                Text(user.data?.email??''),

                RaisedButton(
                  child:Text('Sign Out'),
                  onPressed:()=>_onSignOutPressed(bloc)
                )
              ]);
            }));
  }

  Future<void> _onSignOutPressed(GlobalBloc bloc)async{
   await bloc.signOut(this);
   Navigator.of(context).pushNamed('/auth');
  }

  @override
  void onError(String message) {
     Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void onSuccess() {
    // TODO: implement onSuccess
  }
}
