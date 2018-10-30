import 'package:flutter/material.dart';
import './phone_number.dart';
import './sms_code.dart';
import '../../global_bloc.dart';
import '../../state_provider.dart';
import '../../common/conditional_builder.dart';

class AuthViewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child:StreamBuilder<String>(
      stream: Provider.of<GlobalBloc>(context).verificationId,
      builder: (_, AsyncSnapshot<String> id) {
        return ConditionalBuilder(
          condition:id.hasData&&id.data.isNotEmpty,
          trueBuilder:SMSCodeScreen(),
          falseBuilder: PhoneNumberScreen(),
        );
      },
    ),),);
  }
 
}
