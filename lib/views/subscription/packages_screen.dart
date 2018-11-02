import 'dart:collection';

import 'package:flutter/material.dart';
import '../../scoped_blocs/subscription_bloc.dart';
import '../../models/package_model.dart';
import '../../common/conditional_builder.dart';
import '../../common/loader.dart';
import '../../state_provider.dart';

class PackagesScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Package>>(
      stream: Provider.of<SubscriptionBloc>(context).allPackages,
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
  final String name, desc;
  final int price, comboPrice;

  PackageCard(
      {Key key,
      @required this.name,
      @required this.desc,
      @required this.price,
      @required this.comboPrice})
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
           ! _isCombo
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
           ],),
            RaisedButton(
              child: Text('CHOOSE PACKAGE'),
              onPressed: () {},
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
