import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final user = FirebaseAuth.instance.currentUser;
final userCollection = FirebaseFirestore.instance.collection('users');
final groupCollection = FirebaseFirestore.instance.collection('groups');

final storage = FirebaseStorage.instance.ref();

final paymentCollection = FirebaseFirestore.instance.collection('payment');
