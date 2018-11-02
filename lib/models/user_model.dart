import 'package:firebase_auth/firebase_auth.dart';

class User {
  ///Currently we only have [Place], we should have more informtion stored like
  ///exact [Loacation], [Company]..etc, review with latest architecture changes
  final String uid, phoneNumber, displayName, email, photoUrl, place;
  final bool isNew;
  final int expirationTimeStamp;

  User._(this.uid, this.phoneNumber, this.displayName, this.email,
      this.photoUrl, this.isNew, this.expirationTimeStamp, this.place);
  factory User.fromFirebaseUser(
      FirebaseUser user, Map<String, dynamic> userDoc) {
    return user != null
        ? User._(
            user.uid,
            user.phoneNumber,
            user.displayName,
            user.email,
            user.photoUrl,
            user.displayName == null ? true : false,
            userDoc != null ? userDoc['expirationDate'] : null,
            userDoc != null ? userDoc['place'] : null)
        : null;
  }
  factory User.fromUserChanges(User user, String name, String email) {
    return User._(user.uid, user.phoneNumber, name, email, user.photoUrl, false,
        user.expirationTimeStamp, user.place);
  }
}
