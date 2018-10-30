import 'package:firebase_auth/firebase_auth.dart';
import './error_handler.dart';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  UserUpdateInfo _userInfo = UserUpdateInfo();

  Stream<FirebaseUser> get firebaseUserStream => _auth.onAuthStateChanged;

  Future<void> verifyPhoneNumber(
      String number, ErrorHandler errorHandler, codeSent) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: '+2$number',
        codeSent: codeSent,
        timeout: Duration(seconds: 30),
        verificationFailed: (AuthException e) {
          onAuthError(e, errorHandler);
        },
        verificationCompleted: null,
        codeAutoRetrievalTimeout: null);

  }

  Future<FirebaseUser> signInWithPhoneNumber(
      String code, String verificationId) async {
    return await _auth.signInWithPhoneNumber(
        smsCode: code, verificationId: verificationId);
  }

  String onAuthError(dynamic exp, ErrorHandler errorHandler) {
    errorHandler.onError(exp.message);
    return exp.message;
  }
}
