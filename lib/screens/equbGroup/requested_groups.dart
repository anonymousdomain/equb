import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
      color: Theme.of(context).textTheme.bodyText1!.color,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      body: FutureBuilder(
        future: groupCollection.where('groupRequest', isGreaterThan: []).get(),
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
          List<Future<DocumentSnapshot>> userDocFuture = [];
          snapshot.data!.docs.forEach((doc) {
            String groupId = doc.id;
            List<String> usersId =
                List<String>.from(doc.data()['groupRequest']);
            usersId.forEach((id) {
              userDocFuture.add(userCollection.doc(id).get().then((userDoc) {
                userDoc.reference.update({'groupId': groupId});
                return userDoc;
              }));
            });
          });

          return FutureBuilder(
            future: getUserDocs(userDocFuture),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'Result Not Found',
                    style: textStyle,
                  ),
                );
              }
              List<DocumentSnapshot> userDocs = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                shrinkWrap: true,
                itemCount: userDocs.length,
                itemBuilder: ((context, index) {
                  String groupId = userDocs[index].get('groupId');
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(userDocs[index].get('imageUrl')),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'user',
                                style: textStyle,
                              ),
                              Text(
                                "${userDocs[index].get('firstName')} ${userDocs[index].get('lastName')}",
                                style: textStyle,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'groupName',
                                style: textStyle,
                              ),
                              SizedBox(
                                  child: FutureBuilder(
                                future: groupCollection.doc(groupId).get(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: Text(
                                        'no data',
                                        style: textStyle,
                                      ),
                                    );
                                  }
                                  // List<DocumentSnapshot> groupDoc = snapshot.data;
                                  return Text(snapshot.data?.get('groupName'),
                                      style: textStyle);
                                }),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('status ', style: textStyle),
                              Text('requested', style: textStyle)
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextButtonIcon(
                                    color: Colors.red,
                                    icon: FeatherIcons.xOctagon,
                                    text: 'cancel'),
                                CustomTextButtonIcon(
                                    color: Theme.of(context).primaryColor,
                                    icon: FeatherIcons.checkCircle,
                                    text: 'approve'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
          );
        }),
      ),
    );
  }
}
