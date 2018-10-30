import 'package:flutter/material.dart';
import '../../global_bloc.dart';
import '../../state_provider.dart';
import '../../error_handler.dart';

class NameEmailScreen extends StatefulWidget {
  @override
  _NameEmailScreenState createState() => new _NameEmailScreenState();
}

class _NameEmailScreenState extends State<NameEmailScreen> implements ErrorHandler {
  String _name;
  String _email;
  @override
  Widget build(BuildContext context) {
     final GlobalBloc bloc = Provider.of<GlobalBloc>(context);
    return Column(
      mainAxisAlignment:MainAxisAlignment.center,
      crossAxisAlignment:CrossAxisAlignment.center,
      children:[
        TextField(
              onChanged: (String name) {
                _name = name;
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  prefix: Icon(Icons.person),
                  hintText: 'My Name',
                  labelText: 'Please enter your name'),
            ),
        TextField(
              onChanged: (String email) {
                _email = email;
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  prefix: Icon(Icons.email),
                  hintText: 'E-mail',
                  labelText: 'Please enter your email'),
                  
            ),
             RaisedButton(
              child: Text('SAVE'),
              onPressed: () =>_onSaveButtonPressed(bloc))
            
      ]
    );
  }
void _onSaveButtonPressed(GlobalBloc bloc){
  bloc.updateUserInfo(_name, _email, this);
}
  @override
  void onError(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}