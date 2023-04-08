import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? bankName;
  final String? bankNumber;
  final String? imageUrl;
  final String? phoneNumber;

  User(
      {this.firstName,
      this.lastName,
      this.bankName,
      this.bankNumber,
      this.imageUrl,
      this.phoneNumber,
      this.id,
      this.uid});

//convert map to user instance
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.get('id'),
      uid: doc.get('uid'),
      firstName: doc.get('firstName'),
      phoneNumber: doc.get('phoneNumber'),
      lastName: doc.get('lastName'),
      bankName: doc.get('bankName'),
      bankNumber: doc.get('bankNumber'),
      imageUrl: doc.get('imageUrl'),
    );
  }
  factory User.fromMap(Map<String, dynamic> map, {String? id}) {
    return User(
      id: id,
      firstName: map['firstName'],
      lastName: map['lastName'],
      bankName: map['bankName'],
      bankNumber: map['bankNumber'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      uid: map['uid'],
    );
  }
 
  //convert user instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'firstName': firstName,
      'phoneNumber': phoneNumber,
      'lastName': lastName,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'imageUrl': imageUrl,
    };
  }
}
