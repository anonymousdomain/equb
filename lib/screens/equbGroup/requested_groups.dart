import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/screens/equbGroup/list_of_requested_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// ignore: unused_import
import '../../widget/customtext_iconbutton.dart';

class GroupRequest extends StatefulWidget {
  const GroupRequest({super.key});

  @override
  State<GroupRequest> createState() => _GroupRequestState();
}

class _GroupRequestState extends State<GroupRequest> {
  Future<List<DocumentSnapshot>> getUserDocs(
      List<Future<DocumentSnapshot>> userDocFuture) async {
    return await Future.wait(userDocFuture);
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1!.color,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      body: StreamBuilder(
        stream: groupCollection
            .where('groupRequest', isGreaterThan: []).snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              snapshot.data!.docs == []) {
            return Center(
              child: Text(
                'Result Not Found',
                style: textStyle,
              ),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;

          log(docs.toList().toString());
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final request =
                    List<String>.from(docs[index].get('groupRequest'));
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text(docs[index].get('groupName')),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              '${docs[index].get('members').toList().length.toString()} members',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Chip(
                                      label: Text(
                                          '${docs[index].get("groupRequest").toList().length.toString()} request')),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>ListOfUsersRequested(userIds:request, groupId:docs[index].get('groupId'),)));
                                      },
                                      icon: Icon(FeatherIcons.plusCircle))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }
}
