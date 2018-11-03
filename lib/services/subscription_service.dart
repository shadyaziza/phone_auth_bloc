import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  Future<QuerySnapshot> getAllPackages() async =>
      await Firestore.instance.collection('xPackages').getDocuments();
  Future<DocumentSnapshot> getMealOfId(String uid) async =>
      await Firestore.instance.document('xMeals/$uid').get();
}
