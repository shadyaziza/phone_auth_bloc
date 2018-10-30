import 'package:flutter/material.dart';
import '../../global_bloc.dart';
import '../../state_provider.dart';
import '../../error_handler.dart';

class SMSCodeScreen extends StatefulWidget {
  @override
  SMSCodeScreenState createState() {
    return new SMSCodeScreenState();
  }
}

class SMSCodeScreenState extends State<SMSCodeScreen> implements ErrorHandler {
  String _code;
  @override
  Widget build(BuildContext context) {
    final GlobalBloc bloc = Provider.of<GlobalBloc>(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(children: [
            TextField(
              onChanged: bloc.changeSmsCode,
              maxLength: 6,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  prefix: Icon(Icons.phone_android),
                  hintText: '123456',
                  labelText: 'Please submit your sms code'),
            ),
          ]),
          RaisedButton(
              child: Text('VERIFY'),
              onPressed: () => _onVerifyButtonPressed(bloc)),
          Text('SMS may take up to 30 seconds'),
          GestureDetector(
            onTap:()=>onResendTapped(bloc),
            child: Text('Click here to resend',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blueAccent)),
          )
        ]);
  }

  void _onVerifyButtonPressed(GlobalBloc bloc) {
    bloc.signInWithPhoneNumber( this);
  }
  void onResendTapped(GlobalBloc bloc){
    bloc.resendSMS(this);
  }

  @override
  void onError(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
