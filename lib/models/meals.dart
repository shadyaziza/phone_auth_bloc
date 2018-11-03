class Meal {
  final bool available;
  final String name, desc, uid;

  ///[DateTime.weekday] returns an integer that represents each day of the week
  final List<int> availableDays;
  final List<String> productsKey;
  final int price;

  ///Check [xMeals] collection on Firestore, I am not using all the data, so we should expand on this
  ///model implmentation in the future insha'Allah
  Meal._(
      {this.available,
      this.name,
      this.desc,
      this.uid,
      this.availableDays,
      this.productsKey,
      this.price});

      factory Meal.fromBloc(Map<String,dynamic> mealMap){
        if(mealMap==null){
          return null;
        }
        else{
          List<String> _productKeys=[];
          mealMap['productKeys'].froEach((key,_){
            _productKeys.add(key);
          });
          return Meal._(
            available: mealMap['available'],
            name:mealMap['name'],
            desc:mealMap['description'],
            ///I do not have to do this, but declare a tempotary [List<DateTime>] above the return
            ///and make the logic that checks the keys in [availableDays] map on firestore under 
            ///and choose the apporpriate [int] value for [weekday] in [DateTime],
            ///if you are confused check any meal documnet under [xMeals] collection you will find that
            ///[availableDays] are written like this`mon,sun..` so we need to convert this to be numbers
            ///`7,1,2...` that are used by [DateTime] object to represent [weekday]
            ///`DO NOT use a formatter for this task`
            price: mealMap['price'],
            uid: mealMap['uid'],
            ///We should also have a [Product] model and add to [Meal] class a field of
            ///`List<Product>` just like we have `List<Meal>` under [Package] model
            productsKey: _productKeys
          );
        }
      }
}
