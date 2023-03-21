import 'package:equb/provider/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthState _authState;

  AuthService(this._authState);
  // Future<void> verifyPhoneNumber(String phoneNumber,
  //     Function(PhoneAuthCredential) onVerificationComplete) async {
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      Future<void> verificationCompleted(
          PhoneAuthCredential phoneAuthCredential) async {
        // await onVerificationComplete(phoneAuthCredential);
        await _auth.signInWithCredential(phoneAuthCredential);
        _authState.setStatus(AuthStatus.authenticated);
      }

      void phoneVerificationFailed(FirebaseAuthException authException) {
        if (authException.code == 'invalid-phone-number') {
          print('the provided phone number is not valid');
        }
        _authState.setStatus(AuthStatus.verificationFailed);
        print('error:${authException.message}');
      }

      Future<void> codeSent(
          String verificationId, int? forceResendingToken) async {
        _authState.setStatus(AuthStatus.codeSent);
        _authState.setVerificationId(verificationId);
        _authState.startCountdown();
      }

      void phoneCodeAutoRetrievalTimeout(String verificationId) {
        _authState.setStatus(AuthStatus.codeAutoRetievalTimeout);
        _authState.setVerificationId(verificationId);
      }

      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: phoneVerificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential result = await _auth.signInWithCredential(credential);

      User? user = result.user;

      if (user != null) {
        _authState.setStatus(AuthStatus.authenticated);
      } else {
        _authState.setStatus(AuthStatus.uninitialized);
      }
    } catch (e) {
      print(e.toString());
      _authState.setStatus(AuthStatus.verificationFailed);
    }
  }
}
