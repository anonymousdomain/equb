import 'package:flutter/material.dart';

class GroupsDetail extends StatelessWidget {
  GroupsDetail({required this.groupId,super.key});
  String groupId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text(groupId),
      ),
    );
  }
}
