import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../widget/custom_snackbar.dart';

class NewEqubGroup extends StatefulWidget {
  const NewEqubGroup({super.key});

  @override
  State<NewEqubGroup> createState() => _NewEqubGroupState();
}

class _NewEqubGroupState extends State<NewEqubGroup> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _cancel(groupId, userId) async {
    cancelRequest(groupId, userId)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: CustomSnackBar(
              isSuccess: false,
              message: 'user requested is cancled',
            ))))
        .then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: groupCollection
                    .where('groupRequest', arrayContains: user?.uid)
                    .snapshots(),
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
                      child: Text('Result Not Found'),
                    );
                  }
                  final List<DocumentSnapshot> docs = snapshot.data!.docs;
                  print(docs);
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: ((context, index) {
                      return SizedBox(
                        width: 180,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                              leading: Icon(FeatherIcons.gitPullRequest),
                              title: Text(
                                docs[index].get('groupName'),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .color),
                              ),
                              subtitle: Text(
                                docs[index].get('catagory'),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .color),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'requested',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        _cancel(docs[index].get('groupId'),
                                            user?.uid);
                                      },
                                      icon: Icon(
                                        FeatherIcons.x,
                                        color: Colors.red[600],
                                      ))
                                ],
                              )),
                        ),
                      );
                    }),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
