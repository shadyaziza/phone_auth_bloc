import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './models/user_model.dart';
import './services/auth_service.dart';
import 'package:rxdart/rxdart.dart';
import './error_handler.dart';
import './services/user_service.dart';

class GlobalBloc {
  GlobalBloc() {
    _authService.firebaseUserStream.listen(_sinkUserSubject);
  }
  AuthService _authService = AuthService();
  UserService _userService = UserService();

  BehaviorSubject<User> _userSubject = BehaviorSubject<User>();
  Observable<User> get user => _userSubject.stream;

  BehaviorSubject<bool> _loadingSubject = BehaviorSubject<bool>();
  Observable<bool> get loading => _loadingSubject.stream;

  BehaviorSubject<String> _verificationId = BehaviorSubject<String>();
  Observable<String> get verificationId => _verificationId.stream;

  BehaviorSubject<String> _smsCode = BehaviorSubject<String>();
  Observable<String> get smsCode => _smsCode.stream;
  Function(String) get changeSmsCode => _smsCode.sink.add;

  Future<void> _sinkUserSubject(FirebaseUser user) async {
    _loadingSubject.sink.add(true);
    try {
      DocumentSnapshot userDoc = await _userService.getUserDoc(user.uid);
      _userSubject.sink.add(User.fromFirebaseUser(user, userDoc.data));
    } catch (e) {
      ///A small challenge for you, how to benfit from [ErrorHandler] here
      ///what can we do to bind the UI to give user feedback if an excpetion were to be thrown
      print(e.message);
    }
    _loadingSubject.sink.add(false);
  }

  Future<void> verifyPhoneNumber(
      String number, ErrorHandler errorHandler) async {
    try {
      await _authService.verifyPhoneNumber(number, errorHandler, codeSent);
    } catch (e) {
      errorHandler.onError(e.message);
    }
  }

  PhoneCodeSent get codeSent => (String code, [_]) {
        _verificationId.sink.add(code);
      };

  Future<void> signInWithPhoneNumber(ErrorHandler errorHandler) async {
    try {
      ///Do not be confused, whats is going on here is we are first awaiting [signInWithPhoneNumber],
      ///Which returns a [FirebaseUser] when it completes successfully, then we take this [FirebaseUser],
      ///and pass it to our [Sink] on [User], not that same [Sink] method is used twice if the app booted up with
      ///[User!=null] and also if the user had to sign in from [signInWithPhoneNumber] and was succeffully authenticated.
      await _sinkUserSubject(await _authService.signInWithPhoneNumber(
          _smsCode.value, _verificationId.value));
      errorHandler.onSuccess();
    } catch (e) {
      errorHandler.onError(e.message);
    }
  }

  void resendSMS(ErrorHandler errorHandler) {
    ///Track this question [https://stackoverflow.com/questions/53097029/throttle-function-execution-in-dart?noredirect=1#comment93120018_53097029]
    _smsCode.stream.throttle(Duration(seconds: 3)).listen((_) => () {
          print('delayed');
        });
    _smsCode.throttle(Duration(seconds: 3)).listen((_) => () {
          print('delayed2');
        });
  }

  Future<void> updateUserInfo(
      String name, String email, ErrorHandler errorHandler) async {
    ///Do not want to call [Firebase] with an empty [email] or [name]

    if (name == null || name.isEmpty || email == null || email.isEmpty) {
      errorHandler.onError('Name and email are required');
    } else {
      try {
        await _authService.updateFirebaseUser(
          email: email,
          name: name,
        );
        sinkUserChanges(name, email);
        errorHandler.onSuccess();
      } catch (e) {
        errorHandler.onError(e.message);
      }
    }
  }

  void sinkUserChanges(String name, String email) {
    _userSubject.sink
        .add(User.fromUserChanges(_userSubject.value, name, email));
  }

  Future<void> signOut(ErrorHandler errorHandler) async {
    try {
      _authService.signOut();
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

// typedef void ThrottlerCallback<T>(T args);

// class Throttler<T> {
//   final Duration _delay;
//   final ThrottlerCallback<T> _callback;
//   final bool _noTrailing;

//   Timer _timer;
//   DateTime _lastExecutionTime = new DateTime.now();

//   Throttler(this._delay, this._callback, [this._noTrailing = false]);

//   void callback(T args) {
//     _callback(args);
//   }

//   void throttle(T args) {
//     final Duration elapsed = new DateTime.now().difference(_lastExecutionTime);
//     void execute() {
//       _lastExecutionTime = new DateTime.now();
//       callback(args);
//     }

//     if (elapsed.compareTo(_delay) >= 0) {
//       execute();
//     }
//     if (_timer != null) {
//       _timer.cancel();
//     }
//     if (_noTrailing == false) {
//       _timer = new Timer(_delay, execute);
//     }
//   }
// }
