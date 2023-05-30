import 'package:flutter/material.dart';

class Members extends StatefulWidget {
   Members({super.key,required this.groupId});

  String groupId;
  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('members'),
      ),
    );
  }
}
