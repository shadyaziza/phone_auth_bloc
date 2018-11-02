import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<DocumentSnapshot> getUserDoc(String uid) async =>
      await Firestore.instance.document('/users/$uid').get();
}
