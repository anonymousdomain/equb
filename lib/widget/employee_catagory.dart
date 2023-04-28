
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';


class EmployeeCard extends StatefulWidget {
  const EmployeeCard({super.key});

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: groupsCatagory('Employee'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<DocumentSnapshot> docs = snapshot.data!.docs;
          return SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: docs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 200,
                  child: ListTile(
                    title: Text(docs[index].get('groupName')),
                    subtitle: Text(docs[index].get('catagory')),
                  ),
                );
              },
            ),
          );
        });
  }
}
