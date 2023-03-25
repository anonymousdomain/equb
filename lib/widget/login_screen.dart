// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:equb/helper/auth_service.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:equb/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String? _selectedCountry = '+251';

  @override
  void initState() {
    String message = AuthState().status.toString();
    log('status:$message');
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  AuthService authService = AuthService(AuthState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (() {
                currentTheme.toggleTheme();
              }),
              icon: Icon(Icons.brightness_1))
        ],
      ),
      body: Center(
        child: Consumer<AuthState>(builder: (context, auth, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  auth.status == AuthStatus.uninitialized
                      ? Column(
                          children: [
                            Text(
                              'Your Phone Number',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color),
                            ),
                            Text(
                              'please confirm your country code and enter your phone number',
                              softWrap: true,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color),
                                    controller: _phoneNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      prefixIcon: CountryCodePicker(
                                        initialSelection: 'ET',
                                        favorite: const ['+251', 'ET'],
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCountry = value.dialCode;
                                          });
                                        },
                                      ),
                                      hintText: 'Enter phone number',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.indigo, width: 2),
                                      ),
                                    ),
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        return 'please enter your phone number';
                                      }
                                      return null;
                                    }),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  log(_selectedCountry! +
                                      _phoneNumberController.text.trim());

                                  await Provider.of<AuthState>(context,
                                          listen: false)
                                      .verifyPhoneNumber(_selectedCountry! +
                                          _phoneNumberController.text.trim())
                                      .then((value) => {
                                            auth.setStatus(
                                                AuthStatus.authenticating)
                                          });
                                }
                              },
                              child: Text('submit'),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            auth.status == AuthStatus.authenticating
                                ? CircularProgressIndicator()
                                : Column(
                                    children: [
                                      PinCodeTextField(
                                        appContext: context,
                                        length: 6,
                                        onChanged: (value) {
                                          _pinCodeController.text = value;
                                        },
                                        textStyle: TextStyle(
                                            color: currentTheme.currentTheme ==
                                                    ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black),
                                        keyboardType: TextInputType.number,
                                        pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            fieldHeight: 50,
                                            fieldWidth: 40),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          log(auth.verificationId);
                                          log(_pinCodeController.text);
                                          await Provider.of<AuthState>(context,
                                                  listen: false)
                                              .signInwithPhoneNumber(
                                                  auth.verificationId,
                                                  _pinCodeController.text).then((value) => {
                                                    log(auth.status.toString())
                                                  });
                                        },
                                        child: Text('verify'),
                                      ),
                                    ],
                                  ),
                          ],
                        )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
