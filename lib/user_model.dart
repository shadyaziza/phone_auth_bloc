import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid, phoneNumber, displayName, email, photoUrl;
  final bool isNew;

  User._(
      this.uid, this.phoneNumber, this.displayName, this.email, this.photoUrl, this.isNew);
  factory User.fromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User._(user.uid, user.phoneNumber, user.displayName, user.email,
            user.photoUrl,user.displayName==null?true:false)
        : null;
  }
  factory User.fromUserChanges(User user, String name, String email){
    return User._(user.uid, user.phoneNumber, name, email, user.photoUrl, false);
  }
}
