import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
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
      this.id});

//convert map to user instance
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.get('id'),
      firstName: doc.get('firstName'),
      phoneNumber: doc.get('phoneNumber'),
      lastName: doc.get('lastName'),
      bankName: doc.get('bankName'),
      bankNumber: doc.get('bankNumber'),
      imageUrl: doc.get('imageUrl'),
    );
  }

  //convert user instance to map 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'phoneNumber': phoneNumber,
      'lastName': lastName,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'imageUrl': imageUrl,
    };
  }
}
