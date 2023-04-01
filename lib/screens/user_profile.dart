import 'package:equb/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class UserProifle extends StatefulWidget {
  UserProifle({Key? key}) : super(key: key);

  @override
  State<UserProifle> createState() => _UserProifleState();
}

class _UserProifleState extends State<UserProifle> {
  final _profileFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _userController = TextEditingController();

  final TextEditingController _bankController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _userController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _profileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 70.0,
                    child: Icon(
                      FeatherIcons.plusCircle,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 20,
                    color: currentTheme.currentTheme == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Enter your Related form carfully',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                  initialValue: '',
                  decoration: InputDecoration(
                    focusColor: Theme.of(context).primaryColor,
                    hintText: 'Enter Your First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.indigo, width: 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                  initialValue: '',
                  decoration: InputDecoration(
                    focusColor: Theme.of(context).primaryColor,
                    hintText: 'Enter Your Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.indigo, width: 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                  initialValue: '',
                  decoration: InputDecoration(
                    // prefix: DropdownButtonFormField(
                    //   items: const [],
                    //   onChanged: ,
                    // ),
                    focusColor: Theme.of(context).primaryColor,
                    hintText: 'Enter Your Account',
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
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          onPressed: () {},
          label: Icon(FeatherIcons.arrowRightCircle)),
    ));
  }
}
