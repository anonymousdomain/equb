import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:equb/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/subjects.dart';

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
  String name = '';
  void saveWinner(winn) async {
    groupCollection.doc(widget.groupId).update({
      'winner': FieldValue.arrayUnion([winn])
    });
  }

  Future<List<String>> getUsersName(List<String> usersId) async {
    final List<String> usersName = [];
    QuerySnapshot querySnapshot =
        await groupCollection.where('uid', whereIn: usersId).get();
    querySnapshot.docs.forEach((element) {
      String userName =
          '${element.get('firstName')} ${element.get('lastName')}';
      usersName.add(userName);
    });
    return usersName;
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
      body: StreamBuilder(
          stream: userCollection.where('uid', whereIn: items).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = snapshot.data!.docs;
            return Center(
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
                          reward = docs[controller.value].id;
                        });
                        print('reqa $reward');
                        getUserName(reward).then((value) => {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      content: CustomSnackBar(
                                        message: 'The Winner is $value',
                                        isSuccess: true,
                                        duration: Duration(seconds: 6),
                                      )))
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
                        // for(var i in items)FortuneItem(child: Text('${docs[i].get('firstName')} ${docs[i].get('lastName')}'))
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
            );
          }),
    );
  }
}
      // body: items.length <= 1
      //     ? Center(child: CircularProgressIndicator())
      //     : Center(
      //         child: SizedBox(
      //           height: MediaQuery.of(context).size.width * 0.8,
      //           child: Column(
      //             children: [
      //               Expanded(
      //                 child: FortuneWheel(
      // onFling: () {
      //   controller.add(1);
      // },
      // animateFirst: false,
      // onAnimationStart: () {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       backgroundColor:
      //           Theme.of(context).scaffoldBackgroundColor,
      //       content: CustomSnackBar(
      //           message: 'Eta Is started', isSuccess: true)));
      // },
      // onAnimationEnd: () {
      //   setState(() {
      //     reward = items[controller.value];
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         backgroundColor:
      //             Theme.of(context).scaffoldBackgroundColor,
      //         content: CustomSnackBar(
      //           message: 'The Winner is $reward',
      //           isSuccess: true,
      //           duration: Duration(seconds: 6),
      //         )));
      //   });
      //   saveWinner(reward);
      // },
      // // animateFirst: false,
      //                   physics: CircularPanPhysics(
      //                     duration: Duration(seconds: 10),
      //                     curve: Curves.decelerate,
      //                   ),
      //                   selected: controller.stream,
      //                   items: [
      //                     for (var it in items) FortuneItem(child: Text(it)),
      //                   ],
      //                 ),
      //               ),
      // SizedBox(
      //   height: 10,
      // ),
      // ElevatedButton(
      //   onPressed: () {
      //     setState(() {
      //       controller.add(Fortune.randomInt(0, items.length));
      //     });
      //   },
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Theme.of(context).primaryColor,
      //     foregroundColor:
      //         Theme.of(context).textTheme.headline1!.color,
      //     padding:
      //         EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //   ),
      //   child: Text('Spin'),
      // ),
      //             ],
      //           ),
      //         ),
      //       ),
  
