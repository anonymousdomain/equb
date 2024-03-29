// ignore_for_file: use_build_context_synchronously

import 'package:country_code_picker/country_code_picker.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:equb/utils/theme.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:equb/widget/custom_leading_button.dart';
import 'package:equb/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  void verify() async {
    AuthState provider = Provider.of<AuthState>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      String phoneNumber =
          _selectedCountry! + _phoneNumberController.text.trim();

      await provider.verifyPhoneNumber(phoneNumber).then((value) {
        Provider.of<AuthState>(context, listen: false)
            .setStatus(AuthStatus.authenticating);
      });
      if (provider.status == AuthStatus.codeSent) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomSnackBar(
          message: 'Your Phone is verifyed',
          isSuccess: true,
        )));
      }
    } else {
      if (_phoneNumberController.text.trim().isNotEmpty &&
          _phoneNumberController.text.trim().length != 9) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: CustomSnackBar(
              message: 'Invalid Phone Number Format',
              isSuccess: false,
            )));
      }
      if (_phoneNumberController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: CustomSnackBar(
              message: 'Enter Your Phone Number',
              isSuccess: false,
            )));

        if (provider.status == AuthStatus.verificationFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomSnackBar(
            message: provider.errorMessage,
            isSuccess: false,
          )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthState provider = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              currentTheme.toggleTheme();
            },
            icon: currentTheme.currentTheme == ThemeMode.dark
                ? Icon(FeatherIcons.moon)
                : Icon(FeatherIcons.sun),
          ),
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
                        return '';
                      }
                      if (value.isNotEmpty && value.length != 9) {
                        return '';
                      }
                      if (provider.status == AuthStatus.verificationFailed) {
                        return '';
                      }
                      return null;
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: provider.status == AuthStatus.authenticating
          ? CustomLoadingButton()
          : CustomButton(title: 'enter', onTap: verify),
    );
  }
}
