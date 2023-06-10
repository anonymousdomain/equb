import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/helper/txtref.dart';
import 'package:equb/models/user.dart';
import 'package:equb/service/services.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:chapasdk/chapasdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Payment extends StatefulWidget {
  const Payment(
      {super.key,
      required this.amount,
      required this.groupId,
      required this.schedule});
  final String amount;
  final String groupId;
  final Timestamp schedule;
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  User? _user;
  String _privateKey = '';
  String _message = '';
  final TextEditingController _email = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _currency = TextEditingController();

  final paymentKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _loadProfile();
    // checkUsersPayment();
    _amount.text = widget.amount;
    _currency.text = 'ETB';
    _privateKey = dotenv.env['PRIVATE_KEY']!;
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
  }

  bool isScheduleMatched(Map<String, dynamic> item, DateTime dateTime) {
    Timestamp schedule = item['schedule'] as Timestamp;
    DateTime scheduleDate = schedule.toDate();

    return scheduleDate.year == dateTime.year &&
        scheduleDate.month == dateTime.month;
  }

  void pay() {
    if (paymentKey.currentState!.validate()) {
      Chapa.paymentParameters(
        context: context,
        publicKey: _privateKey,
        currency: _currency.text,
        amount: widget.amount,
        email: _email.text,
        phone: '0${_user!.phoneNumber!.substring(4)}',
        firstName: _user?.firstName ?? 'Dawit',
        lastName: _user?.lastName ?? 'Mekonnen',
        txRef: TextRefGenerator.generateTransactionRef(),
        desc: 'desc',
        namedRouteFallBack: '/checkout',
        title: 'payment',
      );
      groupCollection.doc(widget.groupId).update({
        'payment': FieldValue.arrayUnion([
          {
            'user_id': user!.uid,
            'schedule': widget.schedule.toDate(),
            'amount': widget.amount
          }
        ]),
      });
    }
  }
String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
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
                      validator: emailValidator,
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
