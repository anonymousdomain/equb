import 'package:equb/provider/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber,
      Function(PhoneAuthCredential) onVerificationComplete) async {
    try {
      Future<void> verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
        await onVerificationComplete(phoneAuthCredential);
      }

      void phoneVerificationFailed(FirebaseAuthException authException) {
        if (authException.code == 'invalid-phone-number') {
          print('the provided phone number is not valid');
        }
        print('error:${authException.message}');
      }

      Future<void> codeSent(String verificationId, int? forceResendingToken) async {
        AuthState().setStatus(AuthStatus.codeSent);
        AuthState().setVerificationId(verificationId);
      }

      void phoneCodeAutoRetrievalTimeout(String verificationId) {
        AuthState().setStatus(AuthStatus.codeAutoRetievalTimeout);
        AuthState().setVerificationId(verificationId);
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
        AuthState().setStatus(AuthStatus.authenticated);
      } else {
        AuthState().setStatus(AuthStatus.uninitialized);
      }
    } catch (e) {
      print(e.toString());
      AuthState().setStatus(AuthStatus.verificationFailed);
    }
  }
}
