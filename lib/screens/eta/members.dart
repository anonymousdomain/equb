import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';

class Members extends StatefulWidget {
  Members({super.key, required this.groupId});

  String groupId;
  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  List<String> users = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      users = getUsers(widget.groupId) as List<String>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Card(
                child: Text(users.first),
              );
            }),
      ),
    );
  }
}
