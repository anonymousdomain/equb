import 'package:equb/service/group.dart';
import 'package:flutter/material.dart';

class EqubMember extends StatelessWidget {
  EqubMember({super.key, required this.groupId, required this.query});
  String groupId;
  String query;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsers(groupId, query),
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
            height:270,
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(docs[index].get('imageUrl')),
                    ),
                    title: Text(
                      '${docs[index].get('firstName')} ${docs[index].get('lastName')}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
