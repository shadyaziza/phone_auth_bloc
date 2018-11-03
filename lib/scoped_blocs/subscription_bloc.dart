import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../services/subscription_service.dart';
import '../models/package_model.dart';
import '../models/meals.dart';

class SubscriptionBloc {
  SubscriptionBloc() {
    _getPackages();
    _generateDateList(DateTime.now(), _dateListSubject, 10);
    _generateTimes();
  }
  SubscriptionService _ser = SubscriptionService();
  BehaviorSubject<UnmodifiableListView<Package>> _allPackagesSubject =
      BehaviorSubject<UnmodifiableListView<Package>>();
  Observable<UnmodifiableListView<Package>> get allPackages =>
      _allPackagesSubject.stream;

  ///The generic 10 days that the user need to choose a starting date from
  BehaviorSubject<UnmodifiableListView<DateTime>> _dateListSubject =
      BehaviorSubject<UnmodifiableListView<DateTime>>();
  Observable<UnmodifiableListView<DateTime>> get dates =>
      _dateListSubject.stream;
  BehaviorSubject<Package> _selectedPackageSubject = BehaviorSubject<Package>();
  Observable<Package> get selectedPackage => _selectedPackageSubject.stream;

  Future<void> _getPackages() async {
    List<Package> _ = [];
    try {
      QuerySnapshot packagesQuery = await _ser.getAllPackages();
      packagesQuery.documents.forEach((DocumentSnapshot doc) {
        ///We do not care for [Meal]s right now because this method handles fetching the
        ///all [Package]s so user can select one, we will fetch the meals only when the user
        ///finally selects a certain [Package]
        _.add(Package.fromBloc(doc.data, []));
      });
    } catch (e) {
      ///Same challenge as the one in [GlobalBloc] :D
      print('from _getPackages ${e.toString()}');
    }

    ///We can do the following inside [onSuccess], I will leave that to you to think which is better
    _allPackagesSubject.add(UnmodifiableListView(_));
  }

  Future<void> choosePackage(Package p, bool isCombo) async {
    List<Meal> __=[];
    ///First we get all [Meal]s in the selected package, then we [sink] it
    for (String mealKey in p.mealsKey) {
     DocumentSnapshot  doc= await getMealOfId(mealKey);
      __.add(Meal.fromBloc(doc.data));
    }

    ///This map is useful because it allows me to reuse the same `factory` constructor, so we can have the same
    ///instance updated instead creating new `factory`, our current `factory` expects a `Map<String,dynamic>`
    ///so we are creating this one for this purpose
    Map<String, dynamic> _ = {};

    ///The map must mimic the firstore map (i.e: has the same keys and same value types)
    _.addAll({
      ///Reuse the old value and only update the new ones, in our case we only want to update
      ///`List<Meal>`
      'available': p.available,
      'comboPrice': p.comboPrice,
      'description': p.desc,
      'days': p.days,
      'skippableDays': p.skippableDays,
      'photoUrl': p.photoUrl,
      'allowedMeals': p.mealsKey,
      'name': p.name,

      ///We get [isCombo] information from the UI, if user checked the [CheckBox] then it is combo
      ///otherwise it is `false`
      'isCombo': isCombo,
      'price': p.price,
      'uid': p.uid,

    
    });
    ///Do not get confused, the `_` is the `Map` the `__` is the `List<Meal>` 
    _selectedPackageSubject.sink.add(Package.fromBloc(_, __));
    print(_selectedPackageSubject.value);
  }

  Future<DocumentSnapshot> getMealOfId(String uid) async {
    try {
     return await _ser.getMealOfId(uid);
    } catch (e) {
      print('from gerMealOfId ${e.toString()}');
      return null;
    }
  }

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

  void dispose() {
    _dateListSubject.close();
    _allPackagesSubject.close();
    _selectedPackageSubject.close();
  }
}
