import 'package:equb/utils/theme.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:flutter/material.dart';

class NewEqub extends StatefulWidget {
  const NewEqub({super.key});

  @override
  State<NewEqub> createState() => _NewEqubState();
}

class _NewEqubState extends State<NewEqub> {
  String? _selectedItem;
  final _equbKey = GlobalKey<FormState>();
  final _items = [
    'Regular',
    'Irregural',
    'Non-Stop',
    'Mewww',
  ];
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _moneyamountController = TextEditingController();
  final TextEditingController _roundSizeController = TextEditingController();
  final TextEditingController _scheduleDateController = TextEditingController();
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
                    value: _selectedItem,
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    decoration: InputDecoration(
                      hintText: 'Equb Type',
                        fillColor: Theme.of(context).primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    items: _items.map((item) {
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
                    controller: _scheduleDateController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Enter Schedule',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.indigo, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: CustomButton(title: 'create', onTap: () {}),
    );
  }
}
