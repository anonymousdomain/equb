import 'package:equb/helper/firbasereference.dart';
import 'package:equb/models/user.dart';
import 'package:flutter/material.dart';

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
              Object docs = snapshot.data ?? [];
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CircleAvatar(
                        backgroundImage: NetworkImage(_user?.imageUrl ?? ''),
                      ),
                      titlePadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      title: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          '${_user?.firstName} ${_user?.lastName ?? ''}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15),
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:10,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GridView.builder(
                      clipBehavior:Clip.antiAliasWithSaveLayer,
                        itemCount: 6,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:1.3
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Center(
                              child: Text('Grid Card $index'),
                            ),
                          );
                        }),
                  )
                ],
              );
            }),
      ),
    );
  }
}
