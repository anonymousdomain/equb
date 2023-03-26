import 'package:equb/provider/auth_state.dart';
import 'package:equb/utils/theme.dart';
import 'package:flutter/material.dart';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                    SnackBar snackBar = SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(
                            style: TextStyle(color: Colors.redAccent),
                            Provider.of<AuthState>(context, listen: false)
                                .errorMessage));
                    if (value!.isEmpty) {
                      return ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar).toString();
                      // return Provider.of<AuthState>(context,listen: false).errorMessage;
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Text('sms code will expired in ',
                          style: TextStyle(fontSize: 16, color: Colors.indigo)),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        Provider.of<AuthState>(context, listen: false)
                            .countdown
                            .toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        ' sec',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: signIn,
                  child: Text('verify'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
