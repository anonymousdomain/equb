import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';

class GroupRequest extends StatefulWidget {
  const GroupRequest({super.key});

  @override
  State<GroupRequest> createState() => _GroupRequestState();
}

class _GroupRequestState extends State<GroupRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getGroupRequests(),
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
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 1,
              ),
              itemCount: docs.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: Center(
                    child: Text('Result'),
                  ),
                );
              }));
        }),
      ),
    );
  }
}
