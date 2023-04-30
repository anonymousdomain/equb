import 'package:cloud_firestore/cloud_firestore.dart';
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
      future: groupsCatagory(widget.query),
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
                child: GestureDetector(
                  onTap: joinGroup,
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
