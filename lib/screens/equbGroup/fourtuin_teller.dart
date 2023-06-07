
// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/subjects.dart';

// ignore: must_be_immutable
class FourtuinWheel extends StatefulWidget {
  FourtuinWheel({Key? key, required this.groupId, required this.items})
      : super(key: key);
  String groupId;
  List<String> items;
  @override
  State<FourtuinWheel> createState() => _FourtuinWheelState();
}

class _FourtuinWheelState extends State<FourtuinWheel> {
  // StreamController<int> controller = StreamController.broadcast();
  final controller = BehaviorSubject<int>();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  String reward = '';
  void saveWinner(winn, schedule) async {
    groupCollection.doc(widget.groupId).update({
      'winner': FieldValue.arrayUnion([winn]),
      'schedule': schedule
    });
  }

  Future<DateTime> schedule() async {
    final snapshot = await groupCollection.doc(widget.groupId).get();
    final equbType = snapshot.get('equbType');
    Timestamp date = snapshot.get('schedule');
    final storeddate = date.toDate();
    DateTime scheduleDate = DateTime.now();
    if (equbType == 'monthly') {
      scheduleDate = storeddate.add(Duration(days: 30));
    }
    if (equbType == 'dayliy') {
      scheduleDate = storeddate.add(Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<String> getUserName(String userId) async {
    final querySnapshot = await userCollection.doc(userId).get();

    final String userName =
        '${querySnapshot.get('firstName')} ${querySnapshot.get('lastName')}';
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Spin the Wheel'),
      ),
      body: items.length <= 1
          ? Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'There is no enough people left to spin up equb',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color),
                    ),
                  )),
            )
          : StreamBuilder(
              stream: userCollection.where('uid', whereIn: items).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final docs = snapshot.data!.docs;
                return Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Expanded(
                          child: FortuneWheel(
                            onFling: () {
                              controller.add(1);
                            },
                            animateFirst: false,
                            onAnimationStart: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      content: CustomSnackBar(
                                          message: 'Eta Is started',
                                          isSuccess: true)));
                            },
                            onAnimationEnd: () {
                              setState(() {
                                reward = docs[controller.value].id;
                              });
                              getUserName(reward)
                                  .then((value) => {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                content: CustomSnackBar(
                                                  message:
                                                      'The Winner is $value',
                                                  isSuccess: true,
                                                  duration:
                                                      Duration(seconds: 6),
                                                )))
                                      })
                                  .then((value) => Navigator.pop(context));

                              schedule().then(
                                (value) => saveWinner(reward, value),
                              );
                              // saveWinner(reward);
                            },
                            // animateFirst: false,
                            physics: CircularPanPhysics(
                              duration: Duration(seconds: 10),
                              curve: Curves.decelerate,
                            ),
                            selected: controller.stream,
                            items: [
                              for (var it = 0; it < items.length; it++)
                                FortuneItem(
                                    child: Text(
                                        '${docs[it].get('firstName')} ${docs[it].get('lastName')}')),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              controller
                                  .add(Fortune.randomInt(0, items.length));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor:
                                Theme.of(context).textTheme.headline1!.color,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Spin'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
