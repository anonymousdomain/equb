import 'package:flutter/material.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  verificationFailed,
  codeSent,
  codeAutoRetievalTimeout,
}

class AuthState extends ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;

  String _verificationId = '';

  AuthStatus get status => _status;
  String get verificationId => _verificationId;

  void setVerificationId(String verificationId) {
    _verificationId = verificationId;
    // notifyListeners();
  }

  void setStatus(AuthStatus status) {
    _status = status;

    notifyListeners();
  }
}
