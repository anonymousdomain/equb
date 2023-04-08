import 'dart:io';

import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/services.dart';
import 'package:equb/utils/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class UserProifle extends StatefulWidget {
  const UserProifle({Key? key}) : super(key: key);

  @override
  State<UserProifle> createState() => _UserProifleState();
}

class _UserProifleState extends State<UserProifle> {
  final _profileFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _bankController = TextEditingController();
  String? _selectedItem;
  File? _file;
  String? imageUrl;
  bool isDisposed = false;
  String? id;
  @override
  void initState() {
    super.initState();
    setState(() {
      id = Uuid().v4().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0,8);
    });
  }

  final ImagePicker _picker = ImagePicker();
  void takePhoto(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, maxHeight: 675, maxWidth: 960);
    if (!isDisposed) {
      setState(() {
        _file = File(pickedFile!.path);
      });
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    UploadTask uploadTask = storage
        .child('profiles/${DateTime.now().toString()}.jpg')
        .putFile(imageFile);
    String url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  final _items = [
    'Dashn Bank',
    'Ethiopian Comericial Bank',
    'Abbisinya Bank',
    'Zemen Bank',
  ];

  void register() async {
    String? imageUrl = await uploadImage(_file!);
    if (_profileFormKey.currentState!.validate()) {
      createUserDocument(
        bankName: _bankController.text.trim(),
        bankNumber: _selectedItem,
        firstName: _nameController.text.trim(),
        lastName: _userNameController.text.trim(),
        imageUrl: imageUrl,
        id: id,
      );
    }

    // uploadImage(_file!);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => Home())));
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _bankController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                  onTap: () {
                    takePhoto(ImageSource.gallery);
                  },
                  child: CircleAvatar(
                    backgroundImage: _file != null ? FileImage(_file!) : null,
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 70.0,
                    child: _file == null
                        ? Icon(
                            FeatherIcons.plusCircle,
                            size: 30,
                          )
                        : null,
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
                  'Enter Your Information ',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
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
                  controller: _userNameController,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
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
                DropdownButtonFormField(
                  borderRadius: BorderRadius.circular(10),
                  focusColor: Theme.of(context).primaryColor,
                  value: _selectedItem,
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  decoration: InputDecoration(
                    hintText: 'Bank Type',
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
                  controller: _bankController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                  decoration: InputDecoration(
                    focusColor: Theme.of(context).primaryColor,
                    hintText: 'Enter Your Bank Number',
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
          onPressed: register,
          label: Icon(FeatherIcons.arrowRight)),
    ));
  }
}
