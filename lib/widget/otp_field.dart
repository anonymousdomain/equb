import 'package:equb/provider/auth_state.dart';
import 'package:equb/utils/theme.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:equb/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpField extends StatefulWidget {
  const OtpField({super.key});

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  final TextEditingController _pinCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      String verificationId =
          Provider.of<AuthState>(context, listen: false).verificationId;
      await Provider.of<AuthState>(context, listen: false)
          .signInwithPhoneNumber(verificationId, _pinCodeController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomSnackBar(
        isSuccess: false,
        message: 'invalid otp',
      )));
    }
  }

  void resend() async {
    AuthState provider = Provider.of<AuthState>(context, listen: false);
    await provider.verifyPhoneNumber(provider.phoneNumber);
    provider.setCountDown(30);
  }

  @override
  Widget build(BuildContext context) {
    AuthState provider = context.watch<AuthState>();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
                onPressed: (() {
                  currentTheme.toggleTheme();
                }),
                icon: Icon(FeatherIcons.moon))
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'Check Your Message',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyText1!.color),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "we've sent the code to ",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .headline1!
                              .color
                              ?.withOpacity(0.4),
                        ),
                      ),
                      Text(
                        provider.phoneNumber,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .headline1!
                              .color
                              ?.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onChanged: (value) {
                      _pinCodeController.text = value;
                    },
                    textStyle: TextStyle(
                        color: currentTheme.currentTheme == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 50,
                        fieldWidth: 40),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '';
                      }
                      if (value.isNotEmpty && value.length != 6) {
                        return '';
                      }
                      return null;
                    },
                    onCompleted: (value) {
                      if (value.length == 6) {
                        signIn();
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Text(
                          ' code will expired in - ',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .headline1!
                                .color
                                ?.withOpacity(0.4),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          '${provider.countdown} sec',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .headline1!
                                .color
                                ?.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: provider.status == AuthStatus.codeAutoRetievalTimeout
            ? CustomButton(title: 'signin', onTap: signIn)
            : CustomButton(title: 'resend', onTap: resend));
  }
}
