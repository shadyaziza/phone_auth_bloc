import 'dart:collection';

import 'package:rxdart/rxdart.dart';

class SubscriptionBloc {
  SubscriptionBloc() {
    _generateDateList(DateTime.now(), _dateListSubject, 10);
    _generateTimes();
  }
///The generic 10 days that the user need to choose a starting date from
  BehaviorSubject<UnmodifiableListView<DateTime>> _dateListSubject =
      BehaviorSubject<UnmodifiableListView<DateTime>>();
  Observable<UnmodifiableListView<DateTime>> get dates =>
      _dateListSubject.stream;

  void _generateDateList(DateTime date,
      BehaviorSubject<UnmodifiableListView<DateTime>> subject, int limit) {
    ///Generate a temporary list of next 30 days including today
    List<DateTime> temp = List.generate(30, (i) {
      return date.add(Duration(days: i));
    });
    ///Remove today
    if (date == DateTime.now()) {
      temp.removeAt(0);
    }
    ///Remove tomorrow if it is too late (after 3:00 PM)
    if (DateTime.now().hour > 15) {
      temp.removeAt(0);
    }
    final List<DateTime> finalList = [];
    ///Add all days to [finalList] except fridays and saturdays
    temp.forEach((DateTime date) {
      if (!(date.weekday == DateTime.friday) &&
          !(date.weekday == DateTime.saturday)) {
        finalList.add(date);
      }
    });
    ///Only store the first 10 dates in [dateList],
    ///which is used to populate the [PickerCard]
    subject.sink
        .add(UnmodifiableListView(finalList.getRange(0, limit).toList()));
  }
  ///We do not have dynamic support for delivery time, we should we work on them once we have
  ///backend support (i.e: be able not to hardcode delivery time like the following)
  void _generateTimes() {
    // _timeListSubject.sink.add(UnmodifiableListView(['9:30', '12:30']));
  }

  void dispose(){
    _dateListSubject.close();
  }
}
