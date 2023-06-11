import 'package:equb/helper/firbasereference.dart';
import 'package:equb/screens/eta/member_widget.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../service/services.dart';

class Members extends StatefulWidget {
  Members({super.key, required this.groupId, required this.notpayd});
  String groupId;
  List<String> notpayd;
  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  User? _user;
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Members(Equbtegna)',
          style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'All MEMBERS',
                textAlign: TextAlign.left,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            EqubMember(groupId: widget.groupId, query: 'members'),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Members  who wins in the previous round',
                textAlign: TextAlign.left,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            EqubMember(groupId: widget.groupId, query: 'winner'),
            _user?.role == 'admin'
                ? Column(
                    children: [
                      Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Members Who does not pay this  round yet',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      FutureBuilder(
                          future: getUsersUsingListOfId(widget.notpayd),
                          builder: (context, snapshot) {
                            // if (!snapshot.hasData) {
                            //   return Center(
                            //     child: CircularProgressIndicator(),
                            //   );
                            // }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty ||
                                snapshot.data!.docs == []) {
                              return Center(
                                child: Text('Data not Found'),
                              );
                            }
                            final docs = snapshot.data!.docs;
                            return Center(
                              child: SizedBox(
                                height: 220,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: docs.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              docs[index].get('imageUrl')),
                                        ),
                                        title: Text(
                                          '${docs[index].get('firstName')} ${docs[index].get('lastName')}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color),
                                        ),
                                      );
                                    }),
                              ),
                            );
                          })
                    ],
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
