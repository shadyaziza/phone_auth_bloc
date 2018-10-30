import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid, phoneNumber, displayName, email, photoUrl;

  User._(
      this.uid, this.phoneNumber, this.displayName, this.email, this.photoUrl);
  factory User.fromGlobalBloc(FirebaseUser user) {
    return user != null
        ? User._(user.uid, user.phoneNumber, user.displayName, user.email,
            user.photoUrl)
        : null;
  }
}
