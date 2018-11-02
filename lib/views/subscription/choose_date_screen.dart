import 'dart:collection';

import 'package:flutter/material.dart';
import '../../scoped_blocs/subscription_bloc.dart';
import '../../state_provider.dart';
import '../../common/picker_card.dart';

class ChooseDateScreen extends StatefulWidget {
  final Function(int) animateToPage;

  ChooseDateScreen({Key key, @required this.animateToPage}) : super(key: key);

  @override
  ChooseDateScreenState createState() {
    return new ChooseDateScreenState();
  }
}

class ChooseDateScreenState extends State<ChooseDateScreen> {
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Provider.of<SubscriptionBloc>(context).dates,
            builder: (_, AsyncSnapshot<UnmodifiableListView<DateTime>> dates) {
              if (!dates.hasData || dates.hasError) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Wrap(
                  children: dates.data.map<Widget>((DateTime date) {
                    return PickerCard(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      smallText: getWeekday(date),
                      bigText: date.day.toString(),
                      borderColor: date == _selectedDate
                          ? Theme.of(context).accentColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      onTap: () {
                        print('tapped');
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    );
                  }).toList(),
                );
              }
            }));
  }

  String getWeekday(DateTime date) {
    List<String> weeks = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weeks[date.weekday - 1];
  }
}
