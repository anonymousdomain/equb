import 'package:equb/helper/firbasereference.dart';
import 'package:equb/widget/customtext_iconbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

import '../screens/home.dart';
import '../service/group.dart';
import 'custom_snackbar.dart';

class GroupInfo extends StatefulWidget {
  GroupInfo({Key? key, required this.groupId}) : super(key: key);
  final String groupId;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Detail'),
      ),
      body: StreamBuilder(
        stream: groupCollection.doc(widget.groupId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final docs = snapshot.data;
          final List<String> request =
              List<String>.from(docs?.get('groupRequest'));
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        docs?.get('imageUrl') == null
                            ? CircleAvatar(
                                radius: 60,
                                child: Icon(FeatherIcons.users),
                              )
                            : CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(docs?.get('imageUrl')),
                              ),
                        SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Center(
                            child: Text(
                              docs?.get('groupName'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Center(
                            child: Text(
                              'id: ${docs?.get('id')}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Expected Size: ${docs?.get('roundSize')}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Members Size: ${docs?.get('members').toList().length.toString()}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Price Amount: ${docs?.get('moneyAmount')}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Schedule Date: ${DateFormat('MMMM dd, yyyy').format(docs?.get('schedule').toDate()).toString()}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextButtonIcon(
                                icon: FeatherIcons.arrowLeft,
                                color: Colors.blue,
                                text: 'back',
                                ontap: () {
                                  Navigator.pop(context);
                                }),
                            request.contains(user?.uid)
                                ? CustomTextButtonIcon(
                                    icon: FeatherIcons.checkCircle,
                                    color: Colors.blue,
                                    text: 'requested',
                                    ontap: () async {},
                                  )
                                : CustomTextButtonIcon(
                                    icon: FeatherIcons.checkCircle,
                                    color: Colors.blue,
                                    text: 'request',
                                    ontap: () async {
                                      await requestJoinGroup(
                                              docs?.get('groupId'))
                                          .then(
                                            (value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                              SnackBar(
                                                content: CustomSnackBar(
                                                  message:
                                                      'You Are Requested to Join Group',
                                                  isSuccess: true,
                                                ),
                                              ),
                                            ),
                                          )
                                          .then(
                                            (value) => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: ((context) => Home()),
                                              ),
                                            ),
                                          );
                                    },
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
