import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket/model/user_model.dart';
import 'package:movie_ticket/utils/checker/network_checker.dart';
import 'package:movie_ticket/utils/common_value/collection_name.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_instance.dart';

Future<String> handleCommonErrorFirebase(
    {required Future<void> Function() handleFunc}) async {
  String errorNetwork = await CheckersUtils.checkNetworkError();
  if (errorNetwork.isEmpty) {
    try {
      await handleFunc();
      return '';
    } on FirebaseAuthException catch (e) {
      return e.message ?? CommonMessage.commonError;
    } catch (e) {
      return e.toString();
    }
  } else {
    return errorNetwork;
  }
}

class FirebaseAuth {
  static Future<String> createUserWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    String result = '';
    result = await handleCommonErrorFirebase(handleFunc: () async {
      await authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = authInstance.currentUser;
      final String? uID = user?.uid;

      await fireStoreInstance.collection('users').doc(uID).set(
            UserModel(
              uID,
              name,
              email,
              password,
              CommonMessage.roleUser,
            ).toMap(),
          );
    });
    return result;
  }

  static Future<String> signInWithEmailPassword(
      {required String email, required String password}) async {
    String result = '';
    result = await handleCommonErrorFirebase(handleFunc: () async {
      await authInstance.signInWithEmailAndPassword(
          email: email, password: password);
    });
    return result;
  }

  // Get user by userId
  static Future<UserModel?> getUser() async {
    final User? user = authInstance.currentUser;
    final String? uID = user?.uid;
    final QuerySnapshot querySnapshot = await fireStoreInstance
        .collection(CollectionName.users)
        .where('id', isEqualTo: uID)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return UserModel.fromDocument(querySnapshot.docs.first);
    }

    return null;
  }
}
