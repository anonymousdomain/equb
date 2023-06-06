import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompletedEqub extends StatefulWidget {
  const CompletedEqub({super.key, required this.groupId});

  final String groupId;
  @override
  State<CompletedEqub> createState() => _CompletedEqubState();
}

class _CompletedEqubState extends State<CompletedEqub> {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1!.color,
      fontSize: 14,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equb status Your Status',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: FutureBuilder(
        future: groupCollection.doc(widget.groupId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data;
          List<String> win = List<String>.from(docs!.get('winner'));
          // Timestamp stamp = docs.get('schedule');
          // DateTime storedDate = stamp.toDate();
          if (win.contains(user?.uid)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You Already take Your Prize',
                    style: textStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'The Next Round is on ${DateFormat('MMMM dd,yyyy').format(docs.get('schedule').toDate()).toString()}',
                    style: textStyle,
                  )
                ],
              ),
            );
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Time will come soon!',
                style: textStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'The Next Round is on ${DateFormat('MMMM dd,yyyy').format(docs.get('schedule').toDate()).toString()}',
                style: textStyle,
              )
            ],
          ));
        },
      ),
    );
  }
}
