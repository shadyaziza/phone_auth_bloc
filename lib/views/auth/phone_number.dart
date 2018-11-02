import 'package:flutter/material.dart';
import '../../global_bloc.dart';
import '../../state_provider.dart';
import '../../error_handler.dart';

class PhoneNumberScreen extends StatefulWidget {
  @override
  PhoneNumberScreenState createState() {
    return new PhoneNumberScreenState();
  }
}

class PhoneNumberScreenState extends State<PhoneNumberScreen>
    implements ErrorHandler {
  String _number;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc bloc = Provider.of<GlobalBloc>(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(children: [
            TextField(
              onChanged: (String number) {
                _number = number;
              },
              maxLength: 11,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  prefix: Icon(Icons.phone_android),
                  hintText: '01234567890',
                  labelText: 'Please submit your phone number'),
            ),
          ]),
          RaisedButton(
              child: Text('SUBMIT'),
              onPressed: () => _onSubmitButtonPressed(bloc))
        ]);
  }

  void _onSubmitButtonPressed(GlobalBloc bloc) {
    bloc.verifyPhoneNumber(_number,this);
    
  }

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
