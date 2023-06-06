import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/firbasereference.dart';

String groupId = '';
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
    required catagory,
    required imageUrl}) async {
  final groupDoc = {
    'groupName': groupName,
    'moneyAmount': moneyAmount,
    'roundSize': roundSize,
    'schedule': schedule,
    'equbType': equbType,
    'id': id,
    'uid': user?.uid,
    'members': [user?.uid],
    'groupRequest': [],
    'catagory': catagory,
    'groupId': groupId,
    'createdAt': FieldValue.serverTimestamp(),
    'imageUrl': imageUrl
  };
  final bool docExist = await isDocExist(groupName);
  if (!docExist) {
    DocumentReference docRef = await groupCollection.add(groupDoc);
    groupId = docRef.id;
    await docRef.update({'groupId': groupId});
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

Future<void> requestJoinGroup(groupId) async {
  await groupCollection.doc(groupId).update({
    'groupRequest': FieldValue.arrayUnion([user?.uid])
  });
}

Future<void> approveRequest(groupid, userId) async {
  await groupCollection.doc(groupid).update({
    'groupRequest': FieldValue.arrayRemove([userId])
  });
  await groupCollection.doc(groupid).update({
    'members': FieldValue.arrayUnion([userId])
  });
}

Future<void> cancelRequest(groupId, userId) async {
  await groupCollection.doc(groupId).update({
    'groupRequest': FieldValue.arrayRemove([userId])
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
      .where('members', arrayContains: [user?.uid], isEqualTo: false)
      .get();
  return groupCatagory;
}

Future<QuerySnapshot<Map<String, dynamic>>> getGroupRequests() async {
  return await groupCollection.where('groupRequest', isNull: false).get();
}

Future<List<String>> getUsersName(groupId) async {
  DocumentSnapshot snapshot = await groupCollection.doc(groupId).get();
  List<String> usersId = List<String>.from(snapshot.get('members'));
  QuerySnapshot userSnapshot =
      await userCollection.where('uid', whereIn: usersId).get();

  List<String> userNames = [];
  userSnapshot.docs.forEach((element) {
    String userName = '${element.get('firstName')} ${element.get('lastName')}';
    userNames.add(userName);
  });
  return userNames;
}

Future<QuerySnapshot<Object?>> getUsers(String groupId, String query) async {
  DocumentSnapshot snapshot = await groupCollection.doc(groupId).get();
  List<String> usersId = List<String>.from(snapshot.get(query));
  QuerySnapshot userSnapshot =
      await userCollection.where('uid', whereIn: usersId).get();

  return userSnapshot;
}

Future<QuerySnapshot<Object?>> getWinners(groupId) async {
  DocumentSnapshot snapshot = await groupCollection.doc(groupId).get();
  List<String> usersId = List<String>.from(snapshot.get('winners'));
  QuerySnapshot userSnapshot =
      await userCollection.where('uid', whereIn: usersId).get();

  return userSnapshot;
}

 notify() async {
  final docs = await groupsUsersIn();
  int days = 0;
  docs.docs.toList().forEach((element) {
    Timestamp sche = element.get('schedule');
    DateTime storedDate = sche.toDate();
    DateTime currentDate = DateTime.now();
    Duration diffrence = currentDate.difference(storedDate);
    int daydiffs = diffrence.inDays;

    if (daydiffs <= 10) {
      days++;
    }
  });
  return days;
}
