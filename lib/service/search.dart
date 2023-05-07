import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/screens/home.dart';
import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../widget/custom_snackbar.dart';

class GroupSearch extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
          foregroundColor: theme.textTheme.headline1!.color,
          backgroundColor: theme.primaryColor,
          iconTheme: IconThemeData(color: theme.scaffoldBackgroundColor),
          titleTextStyle: TextStyle(color: theme.textTheme.headline1!.color)),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: theme.textTheme.headline1!.color),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(FeatherIcons.x))
    ];
    // throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(FeatherIcons.arrowLeft));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return StreamBuilder(
      stream: groupCollection.snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return Center(child: Text('nodata'));
        }
        final List<DocumentSnapshot> docs = snapshot.data!.docs
            .where((doc) => doc.get('groupName').toLowerCase().contains(query))
            .toList();
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: ((context, index) {
            final members = List<String>.from(docs[index].get('members'));

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: members.contains(user?.uid)
                  ? ListTile(
                      leading: IconButton(
                          onPressed: () {}, icon: Icon(FeatherIcons.user)),
                      title: Text(
                        docs[index].get('groupName'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle: Text(
                        docs[index].get('catagory'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      onTap: () {
                        query = docs[index].get('groupName');
                      },
                      trailing: Text(
                        '${docs[index].get('members').toList().length.toString()} members ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListTile(
                      leading: IconButton(
                        onPressed: () async {
                          await requestJoinGroup(docs[index].get('groupId'))
                              .then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: CustomSnackBar(
                                        message:
                                            'You Are Requested to Join Group',
                                        isSuccess: true),
                                  ),
                                ),
                              )
                              .then(
                                (value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => Home()),
                                  ),
                                ),
                              );
                        },
                        icon: Icon(
                          FeatherIcons.plusCircle,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        docs[index].get('groupName'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle: Text(
                        docs[index].get('catagory'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      trailing: Text(
                        '${docs[index].get('members').toList().length.toString()} members ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     if (query.isEmpty) {
      return Container();
    }
    return StreamBuilder(
      stream: groupCollection.snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return Center(child: Text('nodata'));
        }
        final List<DocumentSnapshot> docs = snapshot.data!.docs
            .where((doc) => doc.get('groupName').toLowerCase().contains(query))
            .toList();
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: ((context, index) {
            final members = List<String>.from(docs[index].get('members'));

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: members.contains(user?.uid)
                  ? ListTile(
                      leading: IconButton(
                          onPressed: () {}, icon: Icon(FeatherIcons.user)),
                      title: Text(
                        docs[index].get('groupName'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle: Text(
                        docs[index].get('catagory'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      onTap: () {
                        query = docs[index].get('groupName');
                      },
                      trailing: Text(
                        '${docs[index].get('members').toList().length.toString()} members ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListTile(
                      leading: IconButton(
                        onPressed: () async {
                          await requestJoinGroup(docs[index].get('groupId'))
                              .then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: CustomSnackBar(
                                        message:
                                            'You Are Requested to Join Group',
                                        isSuccess: true),
                                  ),
                                ),
                              )
                              .then(
                                (value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => Home()),
                                  ),
                                ),
                              );
                        },
                        icon: Icon(
                          FeatherIcons.plusCircle,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        docs[index].get('groupName'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle: Text(
                        docs[index].get('catagory'),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color),
                      ),
                      trailing: Text(
                        '${docs[index].get('members').toList().length.toString()} members ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            );
          }),
        );
      }),
    );
  }
}
