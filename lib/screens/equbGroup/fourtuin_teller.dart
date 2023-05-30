import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:equb/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/subjects.dart';

class FourtuinWheel extends StatefulWidget {
  FourtuinWheel({Key? key, required this.groupId}) : super(key: key);
  String groupId;
  @override
  State<FourtuinWheel> createState() => _FourtuinWheelState();
}

class _FourtuinWheelState extends State<FourtuinWheel> {
  // StreamController<int> controller = StreamController.broadcast();
  final controller = BehaviorSubject<int>();
  List<String> items = [];
  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // getUsers();
    controller.add(0);
  }

  getUsers() async {
    DocumentSnapshot snapshot = await groupCollection.doc(widget.groupId).get();
    List<String> usersId = List<String>.from(snapshot.get('members'));
    QuerySnapshot userSnapshot =
        await userCollection.where('uid', whereIn: usersId).get();

    List<String> userNames = [];
    userSnapshot.docs.forEach((element) {
      String userName =
          '${element.get('firstName')} ${element.get('lastName')}';
      userNames.add(userName);
    });
    setState(() {
      items = userNames;
    });
  }
  String reward = '';
  void saveWinner(winn) async {
    groupCollection.doc(widget.groupId).update({
      'winner':FieldValue.arrayUnion([winn])
    });
  }
  @override
  Widget build(BuildContext context) {
    getUsers();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Spin the Wheel'),
      ),
      body: items.length <= 1
          ? Center(child: CircularProgressIndicator())
          : Center(
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              content: CustomSnackBar(
                                  message: 'Eta Is started', isSuccess: true)));
                        },
                        onAnimationEnd: () {
                          setState(() {
                            reward = items[controller.value];
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                content: CustomSnackBar(
                                  message: 'The Winner is $reward',
                                  isSuccess: true,
                                  duration: Duration(seconds: 6),
                                )));
                          });
                          saveWinner(reward);
                        },
                        // animateFirst: false,
                        physics: CircularPanPhysics(
                          duration: Duration(seconds: 10),
                          curve: Curves.decelerate,
                        ),
                        selected: controller.stream,
                        items: [
                          for (var it in items) FortuneItem(child: Text(it)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.add(Fortune.randomInt(0, items.length));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).textTheme.headline1!.color,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Spin'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
