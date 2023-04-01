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
        return LoginScreen();
      case AuthStatus.codeSent:
        return OtpField();
      case AuthStatus.verificationFailed:
        return OtpField(message: Provider.of<AuthState>( context,listen: false).errorMessage,);
      case AuthStatus.codeAutoRetievalTimeout:
        return OtpField();
        case AuthStatus.authenticated:
        return Home();
        default:
        return LoginScreen();
    }
  }
}
