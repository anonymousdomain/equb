import '../helper/firbasereference.dart';

Future<void> createGroupDocument({
  required groupName,
  required moneyAmount,
  required roundSize,
  required schedule,
  required equbType,
  required id,
  
}) async {
 final  groupDoc={
'groupName': groupName,
'moneyAmount': moneyAmount,
'roundSize': roundSize,
'schedule': schedule,
'equbType': equbType,
'id': id,
'uid': user?.uid,
  };
  final groupId = groupCollection.doc().id;
  await groupCollection.doc(groupId).set(groupDoc);
}
