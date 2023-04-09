import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/firbasereference.dart';

final groupId = groupCollection.doc().id;
Future<void> createGroupDocument({
  required groupName,
  required moneyAmount,
  required roundSize,
  required schedule,
  required equbType,
  required id,
  required catagory
}) async {
  final groupDoc = {
    'groupName': groupName,
    'moneyAmount': moneyAmount,
    'roundSize': roundSize,
    'schedule': schedule,
    'equbType': equbType,
    'id': id,
    'uid': user?.uid,
    'members': [user?.uid],
    'catagory':catagory,
    'createdAt': FieldValue.serverTimestamp()
  };

  await groupCollection.doc(groupId).set(groupDoc);
}

//join a group
Future<void> joinGroup() async {
  await groupCollection.doc(groupId).update({
    'members': FieldValue.arrayUnion([user?.uid])
  });
}

//leave a group
Future<void> leaveGroup() async {
  await groupCollection.doc(groupId).update({
    'members': FieldValue.arrayRemove([user?.uid])
  });
}

//show list of groups users in

Future<void> groupsUsersIn() async {
  final usersGroup =
      await groupCollection.where('members', arrayContains: user?.uid).get();

  for (final doc in usersGroup.docs) {
    print(doc['groupName']);
  }
}
