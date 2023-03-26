import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;
  String _verificationId = '';
  int _countdown = 30;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  AuthStatus get status => _status;
  String get verificationId => _verificationId;
  int get countdown => _countdown;
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    setPhoneNumber(phoneNumber);
    try {
      Future<void> verificationCompleted(
          PhoneAuthCredential phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
      }

      void phoneVerificationFaild(FirebaseAuthException authException) {
        setStatus(AuthStatus.verificationFailed);
        setErrorMessage(authException.code);
        log('error:${authException.message}');
      }

      Future<void> codeSent(
          String verificationId, int? forceResendingToken) async {
        setStatus(AuthStatus.codeSent);
        setVerificationId(verificationId);
        startCountdown();
      }

      void phoneCodeAutoRetrievalTimeout(String verificationId) {
        if (status != AuthStatus.authenticated) {
          setStatus(AuthStatus.codeAutoRetievalTimeout);
        }
        setVerificationId(verificationId);
        startCountdown();
      }

      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: phoneVerificationFaild,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      if (_user == null) {
        setStatus(AuthStatus.uninitialized);
      } else {
        setStatus(AuthStatus.authenticated);
      }
    } catch (e) {
      print(e.toString());
      setStatus(AuthStatus.verificationFailed);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    setStatus(AuthStatus.uninitialized);
    // notifyListeners();
  }

  void setVerificationId(String verificationId) {
    _verificationId = verificationId;
    // notifyListeners();
  }

  void setStatus(AuthStatus status) {
    Future.delayed(Duration(seconds: 1), () {
      _status = status;
      notifyListeners();
    });
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setCountDown(int countdown) {
    _countdown = countdown;
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
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
