// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:equb/helper/auth_service.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:equb/widget/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    String message = AuthState().status.toString();
    log('status:$message');
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  AuthService authService = AuthService(AuthState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Your Phone Number'),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.indigo, width: 2))),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'please entery your phone number';
                    }
                    return null;
                  }),
                ),
                SizedBox(
                  height: 16,
                ),
                // if(Provider.of<AuthState>(context).status==AuthStatus.uninitialized){
                  
                // }
               Provider.of<AuthState>(context).status==AuthStatus.uninitialized ? 
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await Provider.of<AuthState>(context,listen: false).verifyPhoneNumber(_phoneNumberController.text.trim());
                    }
                  },
                  child: Text('submit'),
                ):SizedBox(
                  child: Text(Provider.of<AuthState>(context,listen: false).status.toString()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
