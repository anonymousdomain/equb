import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/screens/equbGroup/equbs_in.dart';
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
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = groupCollection.snapshots();
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
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                onChanged: (value) {
                  _stream = groupCollection
                      .where('groupName', isEqualTo: value)
                      .orderBy('groupName')
                      .snapshots();
                },
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1!.color),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: Icon(FeatherIcons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
                  hintText: 'Search',
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'Search Result is empty';
                  }
                  return null;
                }),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
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
                  final List<DocumentSnapshot> docs = snapshot.data!.docs.where((doc) =>!doc.get('members').contains(user!.uid)).toList();
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1),
                    itemCount: docs.length,
                    itemBuilder: ((context, index) {
                      return SizedBox(
                        width: 180,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(children: [
                            ListTile(
                              leading: Icon(FeatherIcons.user),
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await requestJoinGroup(
                                              docs[index].get('groupId'))
                                          .then(
                                            (value) =>
                                                ScaffoldMessenger.of(context)
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
                                                builder: ((context) =>
                                                    GroupsIn()),
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
                            ),
                          ]),
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
