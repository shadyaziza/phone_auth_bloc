import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import './user_model.dart';
import './firebase_service.dart';
import 'package:rxdart/rxdart.dart';
import './error_handler.dart';
// import './throttle.dart';

class GlobalBloc {
  GlobalBloc() {
    _loadingSubject.sink.add(true);
    _firebaseService.firebaseUserStream.listen(_sinkUserSubject);
    _loadingSubject.sink.add(false);
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
  Observable<String> get smsCode=>_smsCode.stream;
  Function(String) get changeSmsCode=>_smsCode.sink.add;

  void _sinkUserSubject(user) {
    _userSubject.sink.add(User.fromGlobalBloc(user));
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

  Future<void> signInWithPhoneNumber(
     ErrorHandler errorHandler) async {
    _errorHandler = errorHandler;
    try {
      _userSubject.sink.add(User.fromGlobalBloc(await _firebaseService
          .signInWithPhoneNumber(_smsCode.value, _verificationId.value)));
    } catch (e) {
      errorHandler.onError(e.message);
    }
  }
  
  void resendSMS(ErrorHandler errorHandler){
   smsCode.throttle(Duration(seconds:30)).listen((_)=>signInWithPhoneNumber(errorHandler);
  }
  void dispose() {
    _userSubject.close();
    _loadingSubject.close();
    _verificationId.close();
    _smsCode.close();
  }
}
