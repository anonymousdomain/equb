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
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(docs?.get('imageUrl')),
                      ),
                      SizedBox(height: 16),
                      Text(
                        docs?.get('groupName'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Group ID: ${docs?.get('id')}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Group Size: ${docs?.get('roundSize')}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Price Amount: ${docs?.get('moneyAmount')}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Schedule Date: ${DateFormat('MMMM dd, yyyy').format(docs?.get('schedule').toDate()).toString()}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextButtonIcon(
                              icon: FeatherIcons.xOctagon,
                              color: Colors.red,
                              text: 'cancel',
                              ontap: () {
                                Navigator.pop(context);
                              }),
                              request.contains(user?.uid)?
                              CustomTextButtonIcon(
                              icon: FeatherIcons.checkCircle,
                              color: Colors.blue,
                              text: 'requested',
                              ontap: () async {}) :
                          CustomTextButtonIcon(
                              icon: FeatherIcons.checkCircle,
                              color: Colors.blue,
                              text: 'request',
                              ontap: () async {
                                await requestJoinGroup(docs?.get('groupId'))
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
                                          builder: ((context) => Home()),
                                        ),
                                      ),
                                    );
                              })
                        ],
                      )
                    ],
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
