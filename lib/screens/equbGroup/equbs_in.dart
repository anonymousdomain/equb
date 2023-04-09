import 'package:equb/service/group.dart';
import 'package:equb/widget/nav_drawer.dart';
import 'package:flutter/material.dart';

class GroupsIn extends StatefulWidget {
  const GroupsIn({super.key});

  @override
  State<GroupsIn> createState() => _GroupsInState();
}

class _GroupsInState extends State<GroupsIn> {
  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() async {
    await groupsUsersIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('groups in'),
    );
  }
}
