import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  Future<QuerySnapshot> getAllPackages() async =>
      await Firestore.instance.collection('xPackages').getDocuments();
}
