import 'dart:io';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/screens/home.dart';
import 'package:equb/service/services.dart';
import 'package:equb/widget/nav_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.user}) : super(key: key);
  User? user;
  @override
  // ignore: library_private_types_in_public_api
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lasnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bankNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool isDisposed = false;
  File? _file;
  String? _selectedItem;
  String? imageUrl;
  void takePhoto(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, maxHeight: 675, maxWidth: 960);

    if (pickedFile != null && !isDisposed) {
      setState(() {
        _file = File(pickedFile.path);
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
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user?.firstName ?? '';
    _lasnameController.text = widget.user?.lastName ?? '';
    _phoneNumberController.text = widget.user?.phoneNumber ?? '';
    _selectedItem = widget.user?.bankName ?? '';
    _bankNumberController.text = widget.user?.bankNumber ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
    _nameController.dispose();
    _lasnameController.dispose();
    _phoneNumberController.dispose();
    _bankNumberController.dispose();
  }

  void update() async {
    if (_file != null) {
      imageUrl = await uploadImage(_file!);
      final oldRef =
          FirebaseStorage.instance.refFromURL(widget.user!.imageUrl!);
      await oldRef.delete();
    }
    updateUserDocument(
            firstName: _nameController.text,
            lastName: _lasnameController.text,
            bankName: _selectedItem,
            bankNumber: _bankNumberController.text,
            imageUrl: imageUrl ?? widget.user?.imageUrl)
        .then((value) => getUserDocument())
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            IconButton(icon: Icon(FeatherIcons.check), onPressed: update)
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Form(
                key: _editProfileKey,
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        // Open image picker to select a new profile picture
                        takePhoto(ImageSource.gallery);
                      },
                      child: _file != null
                          ? CircleAvatar(
                              radius: 56, backgroundImage: FileImage(_file!))
                          : CircleAvatar(
                              radius: 56,
                              backgroundImage:
                                  NetworkImage(widget.user!.imageUrl ?? ''),
                            ),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        // Open image picker to select a new profile picture
                        takePhoto(ImageSource.gallery);
                      },
                      child: Text(
                        'Change Profile Picture',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'firstName',
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                        controller: _lasnameController,
                        decoration: InputDecoration(
                          labelText: 'lastName',
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        readOnly: true,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'PhoneNumber',
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: DropdownButtonFormField(

                        borderRadius: BorderRadius.circular(10),
                        focusColor: Theme.of(context).primaryColor,
                        value: _selectedItem,
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            //  decoration: InputDecoration.collapsed(hintText: 'Bank Name'),
                        decoration: InputDecoration(
                            hintText: 'Bank Name',
                            fillColor: Theme.of(context).primaryColor,
                            ),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                        items: _items.map((item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedItem = value!;
                          });
                        },
                        isDense: true,
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                        controller: _bankNumberController,
                        decoration: InputDecoration(
                          labelText: 'Bank Number',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
