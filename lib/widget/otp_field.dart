// ignore_for_file: must_be_immutable

import 'package:equb/provider/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OtpPrompt extends StatefulWidget {
  OtpPrompt({super.key, required this.phoneNumber, required this.smsCode});
  String phoneNumber;
  String smsCode;
  @override
  State<OtpPrompt> createState() => _OtpPromptState();
}

class _OtpPromptState extends State<OtpPrompt> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          
          child: Column(
            children: [
              Text(AuthState().status.toString()),
              Text(widget.phoneNumber),
              Text(widget.smsCode),
            ],
          ),
        ),
      ),
    );
  }
}
