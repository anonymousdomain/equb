import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/models/user.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
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
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 160,
                    flexibleSpace: FlexibleSpaceBar(
                      background: SvgPicture.asset(Images.save,fit:BoxFit.cover,),
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      title: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${docs.get('groupName')} group',
                          style: TextStyle(
                              color:Theme.of(context).primaryColor,
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
                          ),
                          CustomGRoupCard(
                            text: 'Members',
                          ),
                          CustomGRoupCard(
                            text: 'Eta',
                          ),
                          CustomGRoupCard(
                            text: 'Completed Equb',
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
    required this.text,
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Center(child: Text(text,style:TextStyle(
        color: Theme.of(context).textTheme.headline1!.color,
        fontSize: 15,
      ),)),
    );
  }
}
