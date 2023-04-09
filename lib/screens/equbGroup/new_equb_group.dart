import 'package:equb/service/group.dart';
import 'package:equb/utils/theme.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NewEqub extends StatefulWidget {
  const NewEqub({super.key});

  @override
  State<NewEqub> createState() => _NewEqubState();
}

class _NewEqubState extends State<NewEqub> {
  String? _selectedItem;
  String? _catagoryItem;
  final _equbKey = GlobalKey<FormState>();
  final _types = [
    'Daily',
    'Weekly',
    'monthly',
  ];

  final _catagory = ['Employee', 'Drivers', 'Bussiness'];
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _moneyamountController = TextEditingController();
  final TextEditingController _roundSizeController = TextEditingController();

  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void createGroup() async {
    final id = Uuid().v4().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 10);
    await createGroupDocument(
        catagory: _catagoryItem,
        groupName: _groupNameController.text,
        moneyAmount: _moneyamountController.text,
        roundSize: _roundSizeController.text,
        schedule: _selectedDate,
        equbType: _selectedItem,
        id: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _equbKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Create New Group',
                    style: TextStyle(
                      fontSize: 20,
                      color: currentTheme.currentTheme == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _groupNameController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Enter Group Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    borderRadius: BorderRadius.circular(10),
                    focusColor: Theme.of(context).primaryColor,
                    value: _catagoryItem,
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    decoration: InputDecoration(
                        hintText: 'Catagory',
                        fillColor: Theme.of(context).primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    items: _catagory.map((item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _catagoryItem = value!;
                      });
                    },
                    isDense: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    borderRadius: BorderRadius.circular(10),
                    focusColor: Theme.of(context).primaryColor,
                    value: _selectedItem,
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    decoration: InputDecoration(
                        hintText: 'Type',
                        fillColor: Theme.of(context).primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    items: _types.map((item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedItem = value!;
                      });
                    },
                    isDense: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _moneyamountController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Money Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _roundSizeController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Enter Round Size',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: ((value) {
                      _selectedDate = value as DateTime?;
                    }),
                    controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : ''),
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    decoration: InputDecoration(
                      labelText: 'Schedule',
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Enter Schedule',
                      suffixIcon: Icon(FeatherIcons.calendar),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: CustomButton(title: 'create', onTap: createGroup),
    );
  }
}
