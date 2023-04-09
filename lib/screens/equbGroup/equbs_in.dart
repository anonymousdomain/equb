import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:equb/models/equb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

class GroupsIn extends StatefulWidget {
  const GroupsIn({super.key});

  @override
  State<GroupsIn> createState() => _GroupsInState();
}

class _GroupsInState extends State<GroupsIn> {
  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() async {
    await groupsUsersIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future:
              groupCollection.where('members', arrayContains: user?.uid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<DocumentSnapshot> docs = snapshot.data!.docs;
            return GridView.builder(
                itemCount: docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, childAspectRatio:1.0),
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            docs[index].get('groupName'),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          CustomListTile(
                              icon: FeatherIcons.feather,
                              lead: 'EqubCatagory',
                              value: docs[index].get('catagory')),
                          CustomListTile(
                              icon: FeatherIcons.activity,
                              lead: 'EqubType',
                              value: docs[index].get('equbType')),
                          CustomListTile(
                              icon: FeatherIcons.dollarSign,
                              lead: 'MoneyAmount',
                              value: docs[index].get('moneyAmount')),
                          CustomListTile(
                              icon: FeatherIcons.users,
                              lead: 'total members',
                              value: docs[index].get('members').toList().length.toString()),
                          CustomListTile(
                            icon: FeatherIcons.calendar,
                            lead: 'Schedule',
                            value: DateFormat('MMMM dd yyyy')
                                .format(docs[index].get('createdAt').toDate())
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

class CustomListTile extends StatelessWidget {
  String lead;
  String value;
  IconData icon;
  CustomListTile({
    Key? key,
    required this.lead,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      autofocus: true,
      // horizontalTitleGap: 0.1,
      leading: Icon(icon),
      title: Text(
        lead,
        style: TextStyle(
            color: Theme.of(context).textTheme.headline1!.color),
      ),
      trailing: Text(
        value,
        style: TextStyle(
            color: Theme.of(context).textTheme.headline1!.color),
      ),
    );
  }
}
