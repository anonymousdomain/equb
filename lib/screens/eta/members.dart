import 'package:equb/helper/firbasereference.dart';
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
        appBar: AppBar(),
        body: FutureBuilder(
            future: getUsers(widget.groupId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final docs = snapshot.data!.docs;
              return Center(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                  return ListTile(leading:CircleAvatar(
                    backgroundImage:NetworkImage(docs[index].get('imageUrl')),
                  ),
                  title:Text('${docs[index].get('firstName')} ${docs[index].get('lastName')}',style:TextStyle(color:Theme.of(context).textTheme.headline1!.color),) ,
                  );
                }),
              );
            }));
  }
}
