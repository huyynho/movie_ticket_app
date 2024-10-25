import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth authInstance = FirebaseAuth.instance;
final User? user = authInstance.currentUser;
final String? userId = user?.uid;
final FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;