import 'dart:collection';

import 'package:flutter/material.dart';
import '../../scoped_blocs/subscription_bloc.dart';
import '../../models/package_model.dart';
import '../../common/conditional_builder.dart';
import '../../common/loader.dart';
import '../../state_provider.dart';

class PackagesScreen extends StatelessWidget {
  final Function(int) animateToPage;

  PackagesScreen({Key key, @required this.animateToPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc bloc = Provider.of<SubscriptionBloc>(context);
    return StreamBuilder<UnmodifiableListView<Package>>(
      stream: bloc.allPackages,
      builder: (_, AsyncSnapshot<UnmodifiableListView<Package>> packages) {
        ///Tired of importing [ConditionalBuilder] :D
        return ConditionalBuilder(
          condition: !packages.hasData || packages.hasError,
          trueBuilder: Loader(),
          falseBuilder: Scaffold(
              body: ListView.builder(
                  itemCount: packages.data?.length,
                  itemBuilder: (_, int index) {
                    return PackageCard(
                      bloc: bloc,
                      package: packages.data[index],
                      animateToPage:animateToPage,
                      comboPrice: packages.data[index]?.comboPrice,
                      desc: packages.data[index]?.desc,
                      name: packages.data[index]?.name,
                      price: packages.data[index]?.price,
                      
                    );
                  })),
        );
      },
    );
  }

 
}

class PackageCard extends StatefulWidget {
  final SubscriptionBloc bloc;
  final Package package;
  final String name, desc;
  final int price, comboPrice;
  // final VoidCallback onChoosePackagePressed;
  final Function(int) animateToPage;

  PackageCard(
      {Key key,
      @required this.package,
      @required this.name,
      @required this.desc,
      @required this.price,
      @required this.comboPrice,
      // @required this.onChoosePackagePressed,
      @required this.bloc, 
      @required this.animateToPage})
      : super(key: key);
  @override
  PackageCardState createState() {
    return new PackageCardState();
  }
}

class PackageCardState extends State<PackageCard> {
  bool _isCombo = false;
  @override
  Widget build(BuildContext context) {
    ///I am rushing the wire up for features and state management before I go,
    ///so it is easier for you to study.
    /// As you can see I do not care about the UI now, yes it is ugly, I agree.
    ///check this one we may use a similar UI insha'Allah: `https://www.youtube.com/watch?v=bmmTY2lHaks`
    return Card(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.name),
            Text(widget.desc),
            !_isCombo
                ? Text('Total: ${widget.price.toString()}')
                : Text('Total: ${widget.comboPrice.toString()}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                  value: _isCombo,
                  onChanged: _changeCombo,
                ),
                Text('Combo')
              ],
            ),
            RaisedButton(
              child: Text('CHOOSE PACKAGE'),
              onPressed: (){
                widget.bloc.choosePackage(widget.package,_isCombo);
                widget.animateToPage(1);
              },
            )
          ]),
    );
  }

  void _changeCombo(bool newVal) {
    setState(() {
      _isCombo = newVal;
    });
  }
}
