import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/screens/equbGroup/equbs_in.dart';
import 'package:equb/service/group.dart';
import 'package:equb/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// ignore: must_be_immutable
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
      future: groupCollection.where('catagory', isEqualTo: widget.query).get(),
      // .where('members', whereIn: [user?.uid]).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty ||
            snapshot.data!.docs == []) {
          return Center(
            child: Text('Group Not Found'),
          );
        }
        final List<DocumentSnapshot> docs = snapshot.data!.docs
            .where((doc) => !doc.get('members').contains(user!.uid))
            .toList();
        return SizedBox(
          height: 140,
          child: ListView.builder(
            itemCount: docs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(children: [
                    ListTile(
                      leading: Icon(FeatherIcons.users),
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            docs[index]
                                .get('members')
                                .toList()
                                .length
                                .toString(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'members',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed: () async {
                              await requestJoinGroup(docs[index].get('groupId'))
                                  .then(
                                    (value) => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: CustomSnackBar(
                                            message:
                                                'You Are Requested to Join Group',
                                            isSuccess: true),
                                      ),
                                    ),
                                  )
                                  .then(
                                    (value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) => GroupsIn()),
                                      ),
                                    ),
                                  );
                            },
                            icon: Icon(
                              FeatherIcons.plusCircle,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
