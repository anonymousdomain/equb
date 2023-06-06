import 'package:equb/helper/firbasereference.dart';
import 'package:equb/screens/eta/member_widget.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';

class Members extends StatefulWidget {
  Members({super.key, required this.groupId});

  String groupId;
  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  // List<String> users = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Members(Equbtegna)',
          style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'All MEMBERS',
              textAlign: TextAlign.left,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          EqubMember(groupId: widget.groupId, query: 'members'),
          Divider(thickness:2,),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Members wins in the previous round',
              textAlign: TextAlign.left,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          EqubMember(groupId: widget.groupId, query:'winner')
        ],
      ),
    );
  }
}
