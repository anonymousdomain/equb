import 'dart:async';
import 'dart:developer';

import 'package:equb/helper/auth_service.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    String message = AuthState().status.toString();
    log('status:$message');
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late bool _isCountdownTimerActive = false;
  late int _countdownTimerSecondsRemaining = 60;
  void _startCountdownTimer() {
    setState(() {
      _isCountdownTimerActive = true;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdownTimerSecondsRemaining -= 1;
      });
      if (_countdownTimerSecondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _isCountdownTimerActive = false;
        });
      }
    });
  }

  // void _stopCountdownTimer() {
  //   if (_countdownTimer != null) {
  //     _countdownTimer.cancel();

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: 'Enter phone number'),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'please entery your phone number';
                    }
                    return null;
                  }),
                  onFieldSubmitted: ((value) async {
                    if (_formKey.currentState!.validate()) {
                      AuthService authService = AuthService();
                      await authService.verifyPhoneNumber(value,
                          (PhoneAuthCredential credential) async {
                        await authService.signInWithPhoneNumber(
                            credential.verificationId!, '123456');
                      });
                    }
                  }),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(AuthState().status.toString()),
                AuthState().status == AuthStatus.codeSent
                    ? TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(hintText: 'enter otp number'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please eneter the otp';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) async {
                          if (_formKey.currentState!.validate()) {
                            AuthService authService = AuthService();
                            await authService.signInWithPhoneNumber(
                                AuthState().verificationId, value);

                            // _stopCountdownTimer();
                          }
                        },
                      )
                    : SizedBox(),
                SizedBox(
                  height: 16,
                ),
                AuthState().status == AuthStatus.authenticating
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            AuthService authService = AuthService();

                            AuthState().setStatus(AuthStatus.authenticating);

                            await authService
                                .verifyPhoneNumber(_phoneNumberController.text,
                                    (PhoneAuthCredential credential) async {
                              await authService.signInWithPhoneNumber(
                                  credential.verificationId!, '');
                            });
                            _startCountdownTimer();
                          }
                        },
                        child: Text('send otp'),
                      ),
                SizedBox(
                  height: 16,
                ),
                _isCountdownTimerActive
                    ? Text(
                        'Otp will expire in $_countdownTimerSecondsRemaining seconds')
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
