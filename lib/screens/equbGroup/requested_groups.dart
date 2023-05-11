import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
              child: Text('Result Not Found'),
            );
          }
          List<Future<DocumentSnapshot>> userDocFuture = [];
          snapshot.data!.docs.forEach((doc) {
            String groupId = doc.id;
            log('groupId $groupId');
            List<String> usersId =
                List<String>.from(doc.data()['groupRequest']);
            usersId.forEach((id) {
              userDocFuture.add(userCollection.doc(id).get().then((userDoc) {
                userDoc.data()!['groupId'] = groupId;
                log(userDoc.data().toString());
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
                  child: Text('Result Not Found'),
                );
              }
              List<DocumentSnapshot> userDocs = snapshot.data!;
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: userDocs.length,
                  itemBuilder: ((context, index) {
                    String groupId = userDocs[index].get('uid');
                    return SizedBox(
                      width: 600,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(children: [
                          ListTile(
                            leading: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('requested')),
                            title: Text(userDocs[index].get('firstName') ?? ''),
                          ),
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: FutureBuilder(
                          //       future: groupCollection.doc(groupId).get(),
                          //       builder: ((context, snapshot) {
                          //         if (snapshot.connectionState ==
                          //             ConnectionState.waiting) {
                          //           return Center(
                          //             child: CircularProgressIndicator(),
                          //           );
                          //         }
                          //         if (!snapshot.hasData) {
                          //           return Center(
                          //             child: Text('no data'),
                          //           );
                          //         }
                          //         // List<DocumentSnapshot> groupDoc = snapshot.data;
                          //         return Text(snapshot.data?.get('id'));
                          //       })),
                          // )
                        ]),
                      ),
                    );
                  }),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
