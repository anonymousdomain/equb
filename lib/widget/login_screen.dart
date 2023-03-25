// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:equb/helper/auth_service.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:equb/utils/theme.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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
  // final TextEditingController _pinCodeController = TextEditingController();

  AuthService authService = AuthService(AuthState());

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Your Phone Number',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  textAlign: TextAlign.center,
                  'please confirm your country code and enter your phone number',
                  softWrap: true,
                  style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .headline1!
                          .color
                          ?.withOpacity(0.4)),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).primaryColor,
                      prefixIcon: CountryCodePicker(
                        searchStyle: TextStyle(
                            color: currentTheme.currentTheme == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor),
                        initialSelection: 'ET',
                        favorite: const ['+251', 'ET'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        textStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value.dialCode;
                          });
                        },
                        dialogBackgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        dialogTextStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                        boxDecoration: BoxDecoration(),
                      ),
                      hintText: 'Enter phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo, width: 2),
                      ),
                    ),
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return 'please enter your phone number';
                      }
                      return null;
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topRight,
                  widthFactor: 6,
                  child: GestureDetector(
                      child: CircleAvatar(
                        maxRadius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          FeatherIcons.arrowRight,
                          size: 30,
                          color: Theme.of(context).textTheme.headline1!.color,
                        ),
                      ),
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          log(_selectedCountry! + _phoneNumberController.text);
                          await Provider.of<AuthState>(context, listen: false)
                              .verifyPhoneNumber(_selectedCountry! +
                                  _phoneNumberController.text)
                              .then((value) => Provider.of<AuthState>(context,listen: false)
                                  .setStatus(AuthStatus.authenticating));
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
