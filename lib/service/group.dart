import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/firbasereference.dart';

final groupId = groupCollection.doc().id;
Future<bool> isDocExist(String groupName) async {
  final QuerySnapshot querySnapshot =
      await groupCollection.where('groupName', isEqualTo: groupName).get();
  return querySnapshot.docs.isNotEmpty;
}

Future<void> createGroupDocument(
    {required groupName,
    required moneyAmount,
    required roundSize,
    required schedule,
    required equbType,
    required id,
    required catagory}) async {
  final groupDoc = {
    'groupName': groupName,
    'moneyAmount': moneyAmount,
    'roundSize': roundSize,
    'schedule': schedule,
    'equbType': equbType,
    'id': id,
    'uid': user?.uid,
    'members': [user?.uid],
    'catagory': catagory,
    'groupId':groupId,
    'createdAt': FieldValue.serverTimestamp()
  };
  final bool docExist = await isDocExist(groupName);
  if (!docExist) {
    await groupCollection.add(groupDoc);
  } else {
    print('document already exists');
  }
}

//join a group
Future<void> joinGroup(groupId) async {
  await groupCollection.doc(groupId).update({
    'members': FieldValue.arrayUnion([user?.uid])
  });
}

//leave a group
Future<void> leaveGroup(groupId) async {
  await groupCollection.doc(groupId).update({
    'members': FieldValue.arrayRemove([user?.uid])
  });
}

//show list of groups users in

Future<QuerySnapshot<Map<String, dynamic>>> groupsUsersIn() async {
  final usersGroup =
      await groupCollection.where('members', arrayContains: user?.uid).get();

  return usersGroup;
}

Future<QuerySnapshot<Map<String, dynamic>>> groupsCatagory(
    String catagoryName) async {
  final groupCatagory = await groupCollection
      .where('catagory', isEqualTo: catagoryName)
      .where('members',arrayContains:[user?.uid], isEqualTo: false)
      .get();
      
  return groupCatagory;
}
