import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/main.dart';
import 'package:equb/service/group.dart';
import 'package:equb/models/equb.dart';
import 'package:flutter/material.dart';
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
            return GridView.builder(
                itemCount: docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.7),
                itemBuilder: (context, index) {
                

                  // final doc = EqubModel.fromDocument(docs[index]);

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            docs[index].get('groupName'),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            docs[index].get('catagory'),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            docs[index].get('equbType'),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            docs[index].get('moneyAmount'),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            docs[index].get('roundSize'),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('MMMM yyyy')
                                .format(docs[index].get('createdAt').toDate())
                                .toString(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
