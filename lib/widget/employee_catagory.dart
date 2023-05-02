import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EmployeeCard extends StatefulWidget {
  EmployeeCard({super.key, required this.query});
  String query;
  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: groupCollection
          .where('catagory', isEqualTo: widget.query).get(),
          // .where('members', whereIn: [user?.uid]).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData|| snapshot.data!.docs.isEmpty ||snapshot.data!.docs==[]) {
          return Center(
            child: Text('Group Not Found'),
          );
        }
        final List<DocumentSnapshot> docs = snapshot.data!.docs.where((doc) => !doc.get('members').contains(user!.uid)).toList();
                return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: docs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200,
                child: GestureDetector(
                  onTap: () {
                    joinGroup(docs[index].get('groupId'));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(FeatherIcons.userCheck),
                      title: Text(
                        docs[index].get('groupName'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle: Text(
                        docs[index].get('catagory'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
