import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:equb/models/equb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

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
      body: FutureBuilder(
          future:
              groupCollection.where('members', arrayContains: user?.uid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<DocumentSnapshot> docs = snapshot.data!.docs;
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    //TODO:implement what will happen when it gets tapped
                    onTap: () {},
                    child: Card(
                      borderOnForeground: true,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: NetworkImage(''),
                        ),
                        title: Text(
                          docs[index].get('groupName'),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .color),
                        ),
                        subtitle: Text(docs[index].get('catagory')),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Text(
                              DateFormat(
                                      'MMMM dd, yyyy') // Replace with your desired format
                                  .format(
                                      docs[index].get('createdAt').toDate())
                                  .toString(),
                            ),
                            Chip(
                              backgroundColor: Colors
                                  .blue, // Replace with your desired color
                              label: Text(
                                docs[index]
                                    .get('members')
                                    .toList()
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  color: Colors
                                      .white, // Replace with your desired text color
                                ),
                              ),
                            ),
                           
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

// ignore: must_be_immutable
