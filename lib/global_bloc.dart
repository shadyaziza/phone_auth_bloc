import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import './user_model.dart';
import './firebase_service.dart';
import 'package:rxdart/rxdart.dart';
import './error_handler.dart';
// import './throttle.dart';

class GlobalBloc {
  GlobalBloc() {
   
    _firebaseService.firebaseUserStream.listen(_sinkUserSubject);
    
  }
  FirebaseService _firebaseService = FirebaseService();
  ErrorHandler _errorHandler;

  BehaviorSubject<User> _userSubject = BehaviorSubject<User>();
  Observable<User> get user => _userSubject.stream;

  BehaviorSubject<bool> _loadingSubject = BehaviorSubject<bool>();
  Observable<bool> get loading => _loadingSubject.stream;

  BehaviorSubject<String> _verificationId = BehaviorSubject<String>();
  Observable<String> get verificationId => _verificationId.stream;

  BehaviorSubject<String> _smsCode = BehaviorSubject<String>();
  Observable<String> get smsCode => _smsCode.stream;
  Function(String) get changeSmsCode => _smsCode.sink.add;

  Future<void> _sinkUserSubject(user)async {
     _loadingSubject.sink.add(true);
    _userSubject.sink.add(User.fromFirebaseUser(user));
    await Future.delayed(Duration(seconds: 2));
    _loadingSubject.sink.add(false);
  }

  Future<void> verifyPhoneNumber(
      String number, ErrorHandler errorHandler) async {
    _errorHandler = errorHandler;
    try {
      await _firebaseService.verifyPhoneNumber(number, errorHandler, codeSent);
    } catch (e) {
      errorHandler.onError(e.message);
    }
  }

  PhoneCodeSent get codeSent => (String code, [_]) {
        _verificationId.sink.add(code);
      };

  Future<void> signInWithPhoneNumber(ErrorHandler errorHandler) async {
    _errorHandler = errorHandler;
    try {
      _userSubject.sink.add(User.fromFirebaseUser(await _firebaseService
          .signInWithPhoneNumber(_smsCode.value, _verificationId.value)));
    } catch (e) {
      errorHandler.onError(e.message);
    }
    
  }

  void resendSMS(ErrorHandler errorHandler) {
    smsCode
        .throttle(Duration(seconds: 30))
        .listen((_) => signInWithPhoneNumber(errorHandler));
  }

  Future<void> updateUserInfo(String name, String email, ErrorHandler errorHandler)async {
    try {
     await _firebaseService.updateFirebaseUser(
        email: email,
        name: name,
      );
    } catch (e) {
      errorHandler.onError(e.message);
    }
  }

  Future<void> sinkUserChanges(String name,String email) async{
   _userSubject.sink.add(User.fromUserChanges(_userSubject.value,name,email));
  }

  Future<void> signOut(ErrorHandler errorHandler) async {
    try {
      _firebaseService.signOut();
    } catch (e) {
      errorHandler.onError(e.message);
    }

    ///We must reset the [verificationId] in order to show [PhoneScreen] instead of [SMSScreen] on [signOut]
    _verificationId.sink.add(null);
  }

  void dispose() {
    _userSubject.close();
    _loadingSubject.close();
    _verificationId.close();
    _smsCode.close();
  }
}
