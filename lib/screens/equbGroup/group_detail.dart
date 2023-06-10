import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/models/user.dart';
import 'package:equb/screens/equbGroup/fourtuin_teller.dart';
import 'package:equb/screens/eta/completed_equb.dart';
import 'package:equb/screens/eta/eta_detail.dart';
import 'package:equb/screens/eta/members.dart';
import 'package:equb/screens/eta/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helper/images.dart';
import '../../service/services.dart';

class GroupsDetail extends StatefulWidget {
  GroupsDetail({required this.groupId, super.key});
  String groupId;

  @override
  State<GroupsDetail> createState() => _GroupsDetailState();
}

class _GroupsDetailState extends State<GroupsDetail> {
  User? _user;
  List<String> items = [];
  List<String> payedUsers = [];
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
  }

  bool isScheduleMatched(Map<String, dynamic> item, DateTime dateTime) {
    Timestamp schedule = item['schedule'] as Timestamp;
    DateTime scheduleDate = schedule.toDate();

    return scheduleDate.year == dateTime.year &&
        scheduleDate.month == dateTime.month;
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1!.color,
      fontSize: 14,
    );
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: groupCollection.doc(widget.groupId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'No data available',
                    style: textStyle,
                  ),
                );
              }
              DocumentSnapshot<Map<String, dynamic>> docs = snapshot.data!;
              Timestamp schedule = docs.get('schedule');
              getUsers() async {
                DocumentSnapshot snapshot =
                    await groupCollection.doc(docs.id).get();
                List<String> usersId =
                    List<String>.from(snapshot.get('members'));
                List<String> winnerId =
                    List<String>.from(snapshot.get('winner'));

                List<String> res = usersId
                    .where((element) => !winnerId.contains(element))
                    .toList();
                List<Map<String, dynamic>> paymentList =
                    List<Map<String, dynamic>>.from(docs.get('payment'));

                Iterable<Map<String, dynamic>> filtrd =
                    paymentList.where((items) {
                  return isScheduleMatched(items, schedule.toDate());
                });
                filtrd.forEach((item) {
                  //collect users id to a list
                  payedUsers.add(item['user_id']);
                });
               List<String>  response=res.where((element)=>payedUsers.contains(element)).toList();
                setState(() {
                  items = response;
                });
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 160,
                    flexibleSpace: FlexibleSpaceBar(
                      background: SvgPicture.asset(
                        Images.life,
                        fit: BoxFit.cover,
                      ),
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      title: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${docs.get('groupName')} group',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 32),
                        ),
                      ),
                      centerTitle: true,
                    ),
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(200),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(_user!.imageUrl ?? ''),
                            ),
                            Text(
                              '${_user!.firstName} ${_user!.lastName}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 24),
                            )
                          ],
                        )),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        shrinkWrap: true,
                        children: [
                          CustomGRoupCard(
                            text: 'Payment',
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Payment(
                                            amount: docs.get('moneyAmount'),
                                            groupId: docs.id,
                                            schedule: docs.get('schedule'),
                                          )));
                            },
                          ),
                          CustomGRoupCard(
                            text: 'Members',
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Members(groupId: docs.id)));
                            },
                          ),
                          CustomGRoupCard(
                              text: 'Eta',
                              ontap: () async {
                                await getUsers();
                                _user!.role == 'admin'
                                    // ignore: use_build_context_synchronously
                                    ? (Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FourtuinWheel(
                                                  groupId: docs.id,
                                                  items: items,
                                                ))))
                                    // ignore: use_build_context_synchronously
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => EtaDetail()));
                              }),
                          CustomGRoupCard(
                            text: 'Completed Equb',
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CompletedEqub(
                                            groupId: docs.id,
                                          )));
                            },
                          ),
                        ]),
                  )
                ],
              );
            }),
      ),
    );
  }
}

class CustomGRoupCard extends StatelessWidget {
  CustomGRoupCard({
    required this.ontap,
    required this.text,
    super.key,
  });
  final String text;
  Function() ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1!.color,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
