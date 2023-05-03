import 'dart:async';

import 'package:equb/helper/firbasereference.dart';
import 'package:equb/models/user.dart';

Future<void> createUserDocument({
  required firstName,
  required lastName,
  required bankName,
  required bankNumber,
  required imageUrl,
  required id,
}) async {
  final phoneNumber = user?.phoneNumber;
  final userData = {
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
    'bankName': bankName,
    'bankNumber': bankNumber,
    'imageUrl': imageUrl,
    'id': id,
    'uid': user?.uid,
    'role': 'memeber'
  };
  await userCollection.doc(user?.uid).set(userData);
}

Future<void> updateUserDocument({
  required firstName,
  required lastName,
  required bankName,
  required bankNumber,
  required imageUrl,
}) async {
  final userData = {
    'firstName': firstName,
    'lastName': lastName,
    'bankName': bankName,
    'bankNumber': bankNumber,
    'imageUrl': imageUrl,
  };
  await userCollection.doc(user?.uid).update(userData);
}

Future<User?> getUserDocument() async {
  final userDoc = await userCollection.doc(user?.uid).get();

  return userDoc.exists ? User.fromDocument(userDoc) : null;
}

// Stream<User?> getUserDocument() {
//   final controller = StreamController<User?>.broadcast();
//   userCollection.doc(user?.uid).snapshots().listen((event) {
//     if (event.exists) {
//       controller.add(User.fromDocument(event));
//     } else {
//       controller.add(null);
//     }
//   });
//   return controller.stream;
// }
