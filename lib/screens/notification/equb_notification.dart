import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

class EqubNotification extends StatelessWidget {
  const EqubNotification({super.key});

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1!.color,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      body: FutureBuilder(
          future: groupsUsersIn(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty ||
                snapshot.data!.docs == []) {
              return Center(
                child: Text('There is not EqubNotification to show'),
              );
            }
            final docs = snapshot.data!.docs;

            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  Timestamp firebaseSchedule = docs[index].get('schedule');
                  DateTime schedule = firebaseSchedule.toDate();
                  DateTime currentDate = DateTime.now();
                  Duration diff = currentDate.difference(schedule);
                  int diffIndays = diff.inDays;
                  if (diffIndays <= 10) {
                    return GestureDetector(
                      onTap: (){},
                      child: Card(
                        borderOnForeground: true,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                      leading:docs[index].get('imageUrl')==null?CircleAvatar(
                          child: Icon(FeatherIcons.bell),
                        ):CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: NetworkImage(docs[index].get('imageUrl')),
                        ),
                        
                      title: Text(
                        docs[index].get('groupName'),
                      ),
                      subtitle: Text(
                          ' group eta schedule will start in ${ DateFormat(
                                    'MMMM dd, yyyy') // Replace with your desired format
                                .format(docs[index].get('schedule').toDate())
                                .toString()}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            backgroundColor: Colors
                                .blue, // Replace with your desired color
                            label: Text(
                              '$diffIndays',
                              style: textStyle,
                            ),
                          ),
                          Text('days left')
                        ],
                      ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('there is no recent notification'),
                    );
                  }
                });
          }),
    );
  }
}
