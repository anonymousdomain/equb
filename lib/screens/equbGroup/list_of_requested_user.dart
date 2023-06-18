import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:equb/widget/custom_snackbar.dart';
import 'package:equb/widget/customtext_iconbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ListOfUsersRequested extends StatefulWidget {
  ListOfUsersRequested(
      {required this.userIds, required this.groupId, super.key});
  List<String> userIds;
  String groupId;
  @override
  State<ListOfUsersRequested> createState() => _ListOfUsersRequestedState();
}

class _ListOfUsersRequestedState extends State<ListOfUsersRequested> {
  Future<List<DocumentSnapshot>> getUserDocs(userFuture) async {
    return await Future.wait(userFuture);
  }

  List<Future<DocumentSnapshot>> userDocFuture = [];
  Future<void> _approve(groupId, userId) async {
    approveRequest(groupId, userId)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: CustomSnackBar(
              isSuccess: true,
              message: 'User request approved to a group successfuly',
            ))))
        .then((value) => Navigator.of(context).pop());
  }

  Future<void> _cancel(groupId, userId) async {
    cancelRequest(groupId, userId)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: CustomSnackBar(
              isSuccess: false,
              message: 'user requested is cancled',
            ))))
        .then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
     var textStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1!.color,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    for (var id in widget.userIds) {
      userDocFuture.add(userCollection.doc(id).get());
    }
    return Scaffold(
      body: FutureBuilder(
          future: getUserDocs(userDocFuture),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'Result Not Found',
                  style: textStyle,
                ),
              );
            }
            List<DocumentSnapshot> usersDoc = snapshot.data ?? [];

            return ListView.builder(
                itemCount: usersDoc.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Theme.of(context).primaryColor,
                                backgroundImage: NetworkImage(
                                    usersDoc[index].get('imageUrl')),
                              ),
                            ),
                            ListTile(
                              title: Text('fullName',style: textStyle,),
                              trailing: Text(
                                style:textStyle,
                                  '${usersDoc[index].get("firstName")} ${usersDoc[index].get("lastName")}'),
                            ),
                            ListTile(
                              title: Text('phoneNumber',style: textStyle,),
                              trailing: Text(usersDoc[index].get('phoneNumber'),style: textStyle,),
                            ),
                            ListTile(
                              title: Text('BankName',style: textStyle,),
                              trailing: Text(usersDoc[index].get('bankName'),style: textStyle,),
                            ),
                            ListTile(
                              title: Text('bankNumber',style: textStyle,),
                              trailing: Text(usersDoc[index].get('bankNumber'),style: textStyle,),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextButtonIcon(
                                    icon: FeatherIcons.xOctagon,
                                    color: Colors.red,
                                    text: 'cancel',
                                    ontap: () {
                                      _cancel(widget.groupId,usersDoc[index].get('uid'));
                                    }),
                                CustomTextButtonIcon(
                                    icon: FeatherIcons.checkCircle,
                                    color: Colors.blue,
                                    text: 'approve',
                                    ontap: () {
                                      _approve(widget.groupId,
                                          usersDoc[index].get('uid'));
                                    })
                              ],
                            )
                          ],
                        )),
                  );
                });
          }),
    );
  }
}
