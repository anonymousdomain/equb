import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final storage = FlutterSecureStorage();

  User? _user;
  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;
  User? get user => _user;
  String _verificationId = '';
  int _countdown = 60;
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
        String errorCode = authException.code;
        if (errorCode == 'invalid-verification-code') {
          setErrorMessage('Invalid verification code');
        } else if (errorCode == 'session-expired') {
          setErrorMessage('Expired Session Please Try Again');
        } else {
          setErrorMessage('You provide invalide sms code');
        }
        // throw Exception(authException.message);
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
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: phoneVerificationFaild,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
    } catch (e) {
      print(e.toString());
      setStatus(AuthStatus.verificationFailed);
      setErrorMessage('You provide invalide sms code');
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
      String token = await userCredential.user!.getIdToken();
      log('from signinwith phone $token');
      await storeToken(token);
      _isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (_user == null) {
        setStatus(AuthStatus.uninitialized);
      } else {
        setStatus(AuthStatus.authenticated);
      }
    } catch (e) {
      print(e.toString());
      setStatus(AuthStatus.verificationFailed);
      setErrorMessage('You provide invalide sms code');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    await deleteToken();
    setStatus(AuthStatus.uninitialized);
  }

  void setVerificationId(String verificationId) {
    _verificationId = verificationId;
  }

  void setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
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

  Future storeToken(token) async {
    await storage.write(key: 'auth', value: token);
  }

  Future getToken() async {
    final token = await storage.read(key: 'auth');
    return token;
  }

  Future deleteToken() async {
    await storage.delete(key: 'auth');
  }

  Future attempt(String? token) async {
    if (token != null) {
      try {
        UserCredential userCredential =
        await _auth.signInWithCustomToken(token);
        _user = userCredential.user;
        setStatus(AuthStatus.authenticated);
      } catch (e) {
        print(e.toString());
        setStatus(AuthStatus.uninitialized);
      }
    } else {
      setStatus(AuthStatus.uninitialized);
    }
  }
}
