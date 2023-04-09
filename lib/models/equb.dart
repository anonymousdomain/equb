import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EqubModel {
  final String? groupName;
  final String? moneyAmount;
  final String? roundSize;
  final String? schedule;
  final String? equbType;
  final String? id;
  final String? uid;
  final String? members;
  final String? catagory;
  final String? createdAt;

  EqubModel(
      {this.groupName,
      this.moneyAmount,
      this.roundSize,
      this.schedule,
      this.equbType,
      this.id,
      this.uid,
      this.members,
      this.catagory,
      required this.createdAt});
  factory EqubModel.fromDocument(DocumentSnapshot doc) {
    return EqubModel(
      id: doc.get('id'),
      uid: doc.get('uid'),
      groupName: doc.get('groupName'),
      moneyAmount: doc.get('moneyAmount'),
      equbType: doc.get('equbType'),
      roundSize: doc.get('roundSize'),
      schedule: doc.get('schedule'),
      members: doc.get('members'),
      catagory: doc.get('catagory'),
      createdAt: DateFormat('MMMM yyyy')
          .format(doc.get('createdAt').toDate())
          .toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'groupName': groupName,
      'moneyAmount': moneyAmount,
      'equbType': equbType,
      'roundSize': roundSize,
      'schedule': schedule,
      'members': members,
      'catagory': catagory,
      'createdAt': createdAt,
    };
  }
}
