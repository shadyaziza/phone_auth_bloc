import './meals.dart';

class Package {
  final String name, desc, uid;
  final int price, comboPrice, skippableDays, days;
  final bool isCombo, available;
  final List<Meal> meals;

  Package._(
      {this.name,
      this.desc,
      this.price,
      this.comboPrice,
      this.skippableDays,
      this.isCombo,
      this.available,
      this.days,
      this.uid,
      this.meals});

  factory Package.fromBloc(Map<String, dynamic> packageMap, List<Meal> meals) {
    return packageMap == null
        ? null
        : Package._(
            available: packageMap['available'],
            comboPrice: packageMap['comboPrice'],
            desc: packageMap['description'],
            days: packageMap['days'],

            ///isCombo is controlled from front-end side, however, I am using a new appraoch I am testing
            ///The idea is to unify the [factory] as much as possible, so anytime [Package] is going to be updated
            ///whether it is from a service call or within the app itself (e.g: user chcks the combo checker),
            ///we will supply [packageMap] with the updates. It should be confusing to you so it is fine.
            isCombo: packageMap['isCombo'] ?? false,
            meals: meals,
            name: packageMap['name'],
            price: packageMap['price'],
            uid: packageMap['uid'],
            skippableDays: packageMap['skippableDays']);
  }
}