import 'dart:async';

import 'package:flutter/material.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  verificationFailed,
  codeSent,
  codeAutoRetievalTimeout,
}

class AuthState with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;

  String _verificationId = '';
  int _countdown = 30;
  AuthStatus get status => _status;
  String get verificationId => _verificationId;
  int get countdown => _countdown;
  void setVerificationId(String verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }

  void setStatus(AuthStatus status) {
    _status = status;

    notifyListeners();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
    notifyListeners();
  }
}
