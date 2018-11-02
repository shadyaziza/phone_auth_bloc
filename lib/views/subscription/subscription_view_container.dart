import 'package:flutter/material.dart';
import '../../state_provider.dart';
import '../../scoped_blocs/subscription_bloc.dart';
import './packages_screen.dart';
import './choose_date_screen.dart';
class SubscriptionViewContainer extends StatefulWidget {
  @override
  SubscriptionViewContainerState createState() {
    return new SubscriptionViewContainerState();
  }
}

class SubscriptionViewContainerState extends State<SubscriptionViewContainer> {
  PageController _pCont;
  SubscriptionBloc _bloc;

  @override
  void initState() {
    print('init');

    ///We are using a [PageView] so we can share the bloc easily across the two screens,
    ///[PakcagesScreen] and [ChooseDateScreen], remember that `ScopedBloc`s are lost
    ///on [Navigator], this approach will prevent the bloc from losing its `State` while
    ///still be able to go back and forth between the two pages freely
    _pCont = PageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(controller: _pCont, children: [
      PackagesScreen(animateToPage:_animateToPage),
      ChooseDateScreen(animateToPage:_animateToPage)
    ]));
  }

  void _animateToPage(int index) {
    _pCont.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }
}
