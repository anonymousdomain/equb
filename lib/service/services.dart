import 'package:equb/helper/firbasereference.dart';

Future<void> createUserDocument(
    {required firstName,
    required lastName,
    required bankName,
    required bankNumber}) async {
  final phoneNumber = user?.phoneNumber;
  final userData = {
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
    'bankName': bankName,
    'bankNumber': bankNumber,
    // 'imageUrl': imageUrl
  };
  await userCollection.doc(user?.uid).set(userData);
}
