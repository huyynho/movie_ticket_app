import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket/model/seat_model.dart';
import 'package:movie_ticket/utils/checker/network_checker.dart';
import 'package:movie_ticket/utils/common_value/collection_name.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_instance.dart';
import 'package:uuid/uuid.dart';

Future<String> handleCommonErrorFirebase(
    {required void Function() handleFunc}) async {
  String errorNetwork = await CheckersUtils.checkNetworkError();
  if (errorNetwork.isEmpty) {
    try {
      handleFunc();
    } on FirebaseAuthException catch (e) {
      return e.message ?? CommonMessage.commonError;
    } catch (_) {
      return CommonMessage.commonError;
    }
    return '';
  } else {
    return errorNetwork;
  }
}

class SeatService {
  //# Add seat
  Future<String> addSeat(SeatModel seat) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance
          .collection(CollectionName.seats)
          .doc(const Uuid().v1())
          .set(seat.toMap());
    });
  }

  //# Update seat
  Future<String> updateSeat(SeatModel seat) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance
          .collection(CollectionName.seats)
          .doc(seat.id)
          .update(seat.toMap());
    });
  }

  //# Get by id
  Future<SeatModel?> getSeatById(String id) async {
    SeatModel? seat;
    await handleCommonErrorFirebase(handleFunc: () async {
      DocumentSnapshot snapshot = await fireStoreInstance
          .collection(CollectionName.seats)
          .doc(id)
          .get();
      if (snapshot.exists) {
        seat = SeatModel.fromDocument(snapshot);
      }
    });

    return seat;
  }

  // Get seats by movieId
  Future<SeatModel?> getSeatsByMovieId(String movieId) async {
    final QuerySnapshot querySnapshot = await fireStoreInstance
        .collection(CollectionName.seats)
        .where('movieId', isEqualTo: movieId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return SeatModel.fromDocument(querySnapshot.docs.first);
    }
    return null;
  }

  // Delete seat by id
  Future<String> deleteSeat(String id) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance.collection(CollectionName.seats).doc(id).delete();
    });
  }
}
