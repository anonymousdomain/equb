import 'package:chapasdk/chapawebview.dart';
import 'package:chapasdk/constants/requests.dart';
import 'package:chapasdk/constants/strings.dart';
import 'package:chapasdk/constants/url.dart';
import 'package:equb/helper/dio.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/helper/txtref.dart';
import 'package:equb/helper/util.dart';
import 'package:equb/models/user.dart';
import 'package:equb/service/services.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:chapasdk/chapasdk.dart';

class Payment extends StatefulWidget {
  const Payment({super.key, required this.amount});
  final String amount;
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  User? _user;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _currency = TextEditingController();
  // final TextEditingController _txtRef = TextEditingController();
  // final TextEditingController _title = TextEditingController();
  // final TextEditingController _desc = TextEditingController();
  final paymentKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _loadProfile();
    _amount.text = widget.amount;
    _currency.text = 'ETB';
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
  }

  void pay() async {
    Chapa.paymentParameters(
      context: context,
      publicKey: PUBLIC_KEY,
      currency: _currency.text,
      amount: _amount.text,
      email: _email.text,
      phone: _user?.phoneNumber ?? '',
      firstName: _user?.firstName ?? '',
      lastName: _user?.lastName ?? '',
      txRef: TextRefGenerator.generate(),
      desc: 'desc',
      namedRouteFallBack: '',
      title: 'payment',
    );
    // intilizeMyPayment(context, authorization, email, phone, amount, currency, firstName, lastName, transactionReference, customTitle, customDescription, fallBackNamedRoute)
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1!.color,
      fontSize: 14,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'payment page',
          style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
                key: paymentKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Start payment process',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Roboto',
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: textStyle,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).primaryColor,
                        hintText: 'Enter Your Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.indigo, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: false,
                      style: textStyle,
                      controller: _currency,
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).primaryColor,
                        hintText: 'currency',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.indigo, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: false,
                      style: textStyle,
                      controller: _amount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).primaryColor,
                        hintText: 'amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.indigo, width: 2),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
      bottomSheet: CustomButton(title: 'pay', onTap: pay),
    );
  }
}
