import 'package:equb/screens/equbGroup/equbs_in.dart';
import 'package:equb/service/group.dart';
import 'package:equb/utils/theme.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:equb/widget/custom_snackbar.dart';
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
  String _message = '';
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
        lastDate: DateTime(2030));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void createGroup() async {
    final id = Uuid().v4().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 10);
    final isDocumentExist = await isDocExist(_groupNameController.text);

    if (_equbKey.currentState!.validate() && !isDocumentExist) {
      await createGroupDocument(
              catagory: _catagoryItem,
              groupName: _groupNameController.text,
              moneyAmount: _moneyamountController.text,
              roundSize: _roundSizeController.text,
              schedule: _selectedDate,
              equbType: _selectedItem,
              id: id)
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomSnackBar(
                  message: 'group created successfully', isSuccess: true))))
          .then((value) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => GroupsIn())));
    }
    if (isDocumentExist) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomSnackBar(
              message: 'Group aleady exsit with a Name', isSuccess: false)));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomSnackBar(message: _message, isSuccess: false)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: const [
        //   Icon(FeatherIcons.bell)
        // ],
        elevation: 0.0,
      ),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _message = 'group name is required';
                        });
                        return '';
                      }
                      if (value.length > 30) {
                        setState(() {
                          _message =
                              'group name  must be less than 30 characters';
                        });
                        return '';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    borderRadius: BorderRadius.circular(10),
                    focusColor: Theme.of(context).primaryColor,
                    value: _catagoryItem ?? _catagory[0],
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _message = 'catagory item is required';
                        });
                        return '';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    borderRadius: BorderRadius.circular(10),
                    focusColor: Theme.of(context).primaryColor,
                    value: _selectedItem ?? _types[0],
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _message = 'equb type is required';
                        });
                        return '';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _message = 'money amount is required';
                        });
                        return '';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _message = 'round size is required';
                        });
                        return '';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _message = 'schedule is  required';
                        });
                        return '';
                      }
                      return null;
                    },
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
