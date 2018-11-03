import 'package:flutter/material.dart';
import './common/loader.dart';
import './global_bloc.dart';
import './state_provider.dart';
import './models/user_model.dart';
import './views/auth/name_email.dart';
import './views/home/home_view.dart';
import './common/conditional_builder.dart';
import './common/loader.dart';
import './views/subscription/subscription_view_container.dart';
import './scoped_blocs/subscription_bloc.dart';

class LandingControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<GlobalBloc>(context).user,
      builder: (_, AsyncSnapshot<User> user) {
        return ConditionalBuilder(
          condition: user.hasData && user.data?.displayName == null,
          trueBuilder: Scaffold(body: NameEmailScreen()),
          falseBuilder: ConditionalBuilder(
            ///Do not be confused! this condition will always show [SubscriptionView], we are doing it this way
            ///to have the full app flow available for testing
            ///The [null] check is useful if the [User] is using the app for the first time, we do not expect them
            ///to have an [expirationDate]
            ///
            ///
            ///`There is a critical issue here, no time for me to fix it, up to you, check the logs to know what I am talking about`
            condition: user.data?.expirationTimeStamp == null ||
                DateTime.fromMillisecondsSinceEpoch(
                        user.data?.expirationTimeStamp)
                    .isAfter(DateTime.now()),
            trueBuilder:  SubscriptionViewContainer(),
            falseBuilder: HomeViewContainer(),
          ),
        );
      },
    );
  }
}
