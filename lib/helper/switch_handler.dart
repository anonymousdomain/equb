import 'package:equb/provider/auth_state.dart';
import 'package:equb/screens/home.dart';
import 'package:equb/widget/login_screen.dart';
import 'package:equb/widget/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchHndler extends StatelessWidget {
  const SwitchHndler({super.key});

  @override
  Widget build(BuildContext context) {
    AuthStatus status = Provider.of<AuthState>(context).status;
    switch (status) {
      case AuthStatus.uninitialized:
        return LoginScreen();
      case AuthStatus.authenticating:
        return CircularProgressIndicator();
      case AuthStatus.codeSent:
        return OtpField();
      case AuthStatus.authenticated:
        return Home();
      case AuthStatus.verificationFailed:
        return Text('error');

      case AuthStatus.codeAutoRetievalTimeout:
        return Text('jke');
    }
  }
}
