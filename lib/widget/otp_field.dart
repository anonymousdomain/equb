// ignore_for_file: must_be_immutable

import 'package:equb/helper/auth_service.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpPrompt extends StatefulWidget {
  OtpPrompt({super.key, required this.phoneNumber});
  String phoneNumber;

  @override
  State<OtpPrompt> createState() => _OtpPromptState();
}

class _OtpPromptState extends State<OtpPrompt> {
  final key = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  AuthService authService = AuthService(AuthState());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              children: [
                Text('Enter Your Otp'),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Enter otp',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                           borderSide:
                              BorderSide(color: Colors.indigo, width: 2))),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'please entery your otp number';
                    }
                    return null;
                  }),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await authService.signInWithPhoneNumber(
                          Provider.of<AuthState>(context,listen: false).verificationId, _otpController.text.trim());
                    },
                    child: Text('otp'))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
